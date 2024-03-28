const std = @import("std");
const ja3_spoof = @import("ja3_spoof").Client;

const T = struct {
    ja3_digest: []const u8,
};

const allocator = std.heap.page_allocator;

pub fn main() !void {
    const client = try ja3_spoof.init(.{
        .allocator = allocator,
        .custom_cookies = "Cookie",
        .custom_user_agent = "ja3 spoof",
        .custom_ciphers = "DHE-DSS-AES256-SHA:AES256-SHA",
        .print_errors = false,
    });
    const response = try client.send("https://tools.scrapfly.io/api/tls");

    const parsed = try std.json.parseFromSlice(T, allocator, response.response, .{ .ignore_unknown_fields = true });
    defer parsed.deinit();

    std.debug.print("status_code: {}\nresponse: {s}\n", .{ response.status_code, parsed.value.ja3_digest });
}
