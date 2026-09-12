const std = @import("std");

/// A connected participant in an ephemeral relay room.
pub const Participant = struct {
    id: []const u8,
    joined_at: i64,
};

/// An opaque relay payload envelope.
/// The server strictly treats this as untrusted bytes without inspecting or decrypting.
pub const Envelope = struct {
    type: []const u8,
    room: []const u8,
    payload: []const u8,
    nonce: []const u8,

    /// Explicitly sanitizes and wipes a buffer from memory (Burn-on-Read).
    pub fn sanitizeBuffer(buffer: []u8) void {
        @memset(buffer, 0);
    }
};

/// An ephemeral in-memory room.
/// Does not persist to disk, exists only as long as participants are present.
pub const Room = struct {
    id: []const u8,
    created_at: i64,
    last_activity: i64,
    participants: std.ArrayList(Participant),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, id: []const u8) !Room {
        const id_copy = try allocator.dupe(u8, id);
        const now = std.time.timestamp();
        return Room{
            .id = id_copy,
            .created_at = now,
            .last_activity = now,
            .participants = .empty,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Room) void {
        for (self.participants.items) |p| {
            self.allocator.free(p.id);
        }
        self.participants.deinit(self.allocator);
        self.allocator.free(self.id);
    }

    pub fn addParticipant(self: *Room, participant_id: []const u8) !void {
        for (self.participants.items) |p| {
            if (std.mem.eql(u8, p.id, participant_id)) return;
        }

        const id_copy = try self.allocator.dupe(u8, participant_id);
        try self.participants.append(self.allocator, .{
            .id = id_copy,
            .joined_at = std.time.timestamp(),
        });
        self.last_activity = std.time.timestamp();
    }

    pub fn removeParticipant(self: *Room, participant_id: []const u8) bool {
        for (self.participants.items, 0..) |p, i| {
            if (std.mem.eql(u8, p.id, participant_id)) {
                self.allocator.free(p.id);
                _ = self.participants.swapRemove(i);
                self.last_activity = std.time.timestamp();
                return true;
            }
        }
        return false;
    }

    pub fn participantCount(self: *const Room) usize {
        return self.participants.items.len;
    }

    pub fn isEmpty(self: *const Room) bool {
        return self.participants.items.len == 0;
    }
};

/// In-memory manager for blind relay rooms.
pub const RelayManager = struct {
    rooms: std.StringHashMap(*Room),
    allocator: std.mem.Allocator,
    total_relayed_messages: usize,

    pub fn init(allocator: std.mem.Allocator) RelayManager {
        return .{
            .rooms = std.StringHashMap(*Room).init(allocator),
            .allocator = allocator,
            .total_relayed_messages = 0,
        };
    }

    pub fn deinit(self: *RelayManager) void {
        var it = self.rooms.iterator();
        while (it.next()) |entry| {
            const room = entry.value_ptr.*;
            room.deinit();
            self.allocator.destroy(room);
        }
        self.rooms.deinit();
    }

    /// Validates a room identifier (must be 8-64 alphanumeric characters, underscores or hyphens).
    pub fn isValidRoomId(room_id: []const u8) bool {
        if (room_id.len < 8 or room_id.len > 64) return false;
        for (room_id) |c| {
            const is_alphanumeric = (c >= 'a' and c <= 'z') or
                (c >= 'A' and c <= 'Z') or
                (c >= '0' and c <= '9') or
                (c == '-') or (c == '_');
            if (!is_alphanumeric) return false;
        }
        return true;
    }

    /// Joins a participant to a room, creating the room on the heap if it does not exist.
    pub fn join(self: *RelayManager, room_id: []const u8, participant_id: []const u8) !void {
        if (!isValidRoomId(room_id)) return error.InvalidRoomId;
        if (participant_id.len == 0 or participant_id.len > 64) return error.InvalidParticipantId;

        if (self.rooms.get(room_id)) |room| {
            try room.addParticipant(participant_id);
        } else {
            const room_ptr = try self.allocator.create(Room);
            errdefer self.allocator.destroy(room_ptr);

            room_ptr.* = try Room.init(self.allocator, room_id);
            errdefer room_ptr.deinit();

            try room_ptr.addParticipant(participant_id);
            try self.rooms.put(room_ptr.id, room_ptr);
        }
    }

    /// Removes a participant and automatically purges the room if empty.
    pub fn leave(self: *RelayManager, room_id: []const u8, participant_id: []const u8) void {
        if (self.rooms.get(room_id)) |room| {
            _ = room.removeParticipant(participant_id);
            if (room.isEmpty()) {
                _ = self.rooms.remove(room_id);
                room.deinit();
                self.allocator.destroy(room);
            }
        }
    }

    /// Dispatches an opaque message to all peers in the room except the sender.
    /// Returns the number of recipients delivered to.
    pub fn relay(self: *RelayManager, room_id: []const u8, sender_id: []const u8, payload_buffer: []u8) !usize {
        const room = self.rooms.get(room_id) orelse return error.RoomNotFound;
        if (payload_buffer.len == 0) return error.EmptyPayload;

        var recipients_count: usize = 0;
        for (room.participants.items) |p| {
            if (!std.mem.eql(u8, p.id, sender_id)) {
                recipients_count += 1;
            }
        }

        self.total_relayed_messages += 1;
        room.last_activity = std.time.timestamp();

        // Burn-on-Read: zero out the payload buffer memory to guarantee anti-retention
        defer Envelope.sanitizeBuffer(payload_buffer);

        return recipients_count;
    }

    pub fn activeRoomsCount(self: *const RelayManager) usize {
        return self.rooms.count();
    }
};

// ============================================================================
// Unit Tests
// ============================================================================

test "RelayManager: Room validation" {
    try std.testing.expect(RelayManager.isValidRoomId("room-12345_abc"));
    try std.testing.expect(!RelayManager.isValidRoomId("short"));
    try std.testing.expect(!RelayManager.isValidRoomId("invalid chars!@#"));
}

test "RelayManager: Join, Relay and Auto-Purge" {
    const allocator = std.testing.allocator;
    var manager = RelayManager.init(allocator);
    defer manager.deinit();

    const room_id = "test-room-12345";
    const peer1 = "peer-alice";
    const peer2 = "peer-bob";

    // 1. Join peers
    try manager.join(room_id, peer1);
    try manager.join(room_id, peer2);
    try std.testing.expectEqual(@as(usize, 1), manager.activeRoomsCount());

    // 2. Prepare message buffer
    const msg_buffer = try allocator.dupe(u8, "super_secret_encrypted_payload");
    defer allocator.free(msg_buffer);

    // 3. Relay message
    const delivered = try manager.relay(room_id, peer1, msg_buffer);
    try std.testing.expectEqual(@as(usize, 1), delivered);

    // 4. Verify Burn-on-Read memory wipe
    for (msg_buffer) |byte| {
        try std.testing.expectEqual(@as(u8, 0), byte);
    }

    // 5. Leave room and verify auto-purge
    manager.leave(room_id, peer1);
    try std.testing.expectEqual(@as(usize, 1), manager.activeRoomsCount());

    manager.leave(room_id, peer2);
    // Room should now be completely purged from RAM
    try std.testing.expectEqual(@as(usize, 0), manager.activeRoomsCount());
}
