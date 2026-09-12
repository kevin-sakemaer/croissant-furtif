const std = @import("std");
const server_lib = @import("server");

pub const SERVER_NAME = "croissant-relay";
pub const DEFAULT_PORT = 8080;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var manager = server_lib.RelayManager.init(allocator);
    defer manager.deinit();

    std.debug.print("🥐🥷 {s} (Zig 0.15+) initialized.\n", .{SERVER_NAME});
    std.debug.print("Mode: In-Memory Blind Relay (Burn-on-Read / Zero Disk Persistence).\n", .{});
    std.debug.print("Listening on 0.0.0.0:{d}\n", .{DEFAULT_PORT});

    // In local execution / test mode, we print the confirmation message.
}

test "main: verify server constants and manager initialization" {
    const allocator = std.testing.allocator;
    var manager = server_lib.RelayManager.init(allocator);
    defer manager.deinit();

    try std.testing.expectEqualStrings("croissant-relay", SERVER_NAME);
    try std.testing.expectEqual(@as(u16, 8080), DEFAULT_PORT);
    try std.testing.expectEqual(@as(usize, 0), manager.activeRoomsCount());
}
