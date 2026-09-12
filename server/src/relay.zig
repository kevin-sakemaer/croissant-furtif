const std = @import("std");
const session = @import("session.zig");

pub const MessageType = enum {
    join,
    leave,
    relay,
    unknown,

    pub fn fromString(str: []const u8) MessageType {
        if (std.mem.eql(u8, str, "join")) return .join;
        if (std.mem.eql(u8, str, "leave")) return .leave;
        if (std.mem.eql(u8, str, "relay")) return .relay;
        return .unknown;
    }
};

pub const InboundMessage = struct {
    type: []const u8,
    room: []const u8,
    peer_id: ?[]const u8 = null,
    payload: ?[]const u8 = null,
    nonce: ?[]const u8 = null,
};

pub const OutboundMessage = struct {
    type: []const u8,
    room: []const u8,
    from: ?[]const u8 = null,
    payload: ?[]const u8 = null,
    nonce: ?[]const u8 = null,
    delivered_to: usize = 0,
};

/// Handles and routes inbound relay protocol requests.
pub const ProtocolHandler = struct {
    manager: *session.RelayManager,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, manager: *session.RelayManager) ProtocolHandler {
        return .{
            .manager = manager,
            .allocator = allocator,
        };
    }

    /// Parses and processes a raw JSON packet.
    pub fn handlePacket(self: *ProtocolHandler, raw_json: []const u8, sender_id: []const u8) !OutboundMessage {
        const parsed = try std.json.parseFromSlice(InboundMessage, self.allocator, raw_json, .{
            .ignore_unknown_fields = true,
        });
        defer parsed.deinit();

        const msg = parsed.value;
        const msg_type = MessageType.fromString(msg.type);

        switch (msg_type) {
            .join => {
                const peer = msg.peer_id orelse sender_id;
                try self.manager.join(msg.room, peer);
                return OutboundMessage{
                    .type = "joined",
                    .room = msg.room,
                    .from = peer,
                    .delivered_to = 1,
                };
            },
            .leave => {
                const peer = msg.peer_id orelse sender_id;
                self.manager.leave(msg.room, peer);
                return OutboundMessage{
                    .type = "left",
                    .room = msg.room,
                    .from = peer,
                    .delivered_to = 0,
                };
            },
            .relay => {
                const payload = msg.payload orelse return error.MissingPayload;
                const nonce = msg.nonce orelse return error.MissingNonce;

                // Make a mutable buffer for Burn-on-Read sanitization
                const payload_buffer = try self.allocator.dupe(u8, payload);
                defer self.allocator.free(payload_buffer);

                const delivered = try self.manager.relay(msg.room, sender_id, payload_buffer);

                return OutboundMessage{
                    .type = "relayed",
                    .room = msg.room,
                    .from = sender_id,
                    .payload = payload,
                    .nonce = nonce,
                    .delivered_to = delivered,
                };
            },
            .unknown => return error.UnknownMessageType,
        }
    }
};

// ============================================================================
// Unit Tests
// ============================================================================

test "ProtocolHandler: Join, Relay and Leave" {
    const allocator = std.testing.allocator;
    var manager = session.RelayManager.init(allocator);
    defer manager.deinit();

    var handler = ProtocolHandler.init(allocator, &manager);

    const peer_alice = "alice-session-1";
    const peer_bob = "bob-session-2";
    const room_id = "room-test-12345";

    // 1. Alice joins
    const join_alice_json =
        \\{"type":"join","room":"room-test-12345","peer_id":"alice-session-1"}
    ;
    const res_alice = try handler.handlePacket(join_alice_json, peer_alice);
    try std.testing.expectEqualStrings("joined", res_alice.type);
    try std.testing.expectEqualStrings(room_id, res_alice.room);

    // 2. Bob joins
    const join_bob_json =
        \\{"type":"join","room":"room-test-12345","peer_id":"bob-session-2"}
    ;
    const res_bob = try handler.handlePacket(join_bob_json, peer_bob);
    try std.testing.expectEqualStrings("joined", res_bob.type);

    // 3. Alice relays opaque encrypted blob
    const relay_json =
        \\{"type":"relay","room":"room-test-12345","payload":"encrypted_ciphertext_base64==","nonce":"iv_base64=="}
    ;
    const res_relay = try handler.handlePacket(relay_json, peer_alice);
    try std.testing.expectEqualStrings("relayed", res_relay.type);
    try std.testing.expectEqual(@as(usize, 1), res_relay.delivered_to);

    // 4. Bob leaves
    const leave_bob_json =
        \\{"type":"leave","room":"room-test-12345","peer_id":"bob-session-2"}
    ;
    _ = try handler.handlePacket(leave_bob_json, peer_bob);

    // 5. Alice leaves -> room purges
    const leave_alice_json =
        \\{"type":"leave","room":"room-test-12345","peer_id":"alice-session-1"}
    ;
    _ = try handler.handlePacket(leave_alice_json, peer_alice);
    try std.testing.expectEqual(@as(usize, 0), manager.activeRoomsCount());
}
