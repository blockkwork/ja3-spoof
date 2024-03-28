const Client = @This();
const std = @import("std");
const C = @import("c.zig");

const Options = struct {
    allocator: std.mem.Allocator,
    custom_cookies: []const u8 = "",
    custom_ciphers: []const u8 = "AES256-SHA:AES128-SHA",
    custom_user_agent: []const u8 = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.100 Safari/537.36",
};

const Response = struct {
    status_code: i64,
    response: [:0]u8,
};

options: Options,

const Error = error{
    CurlError,
};

pub fn init(options: Options) !Client {
    return .{
        .options = options,
    };
}

pub fn send(client: Client, url: ?[]const u8) Error!Response {
    const config: C.Config = .{
        .url = @constCast(@ptrCast(url)),
        .ciphers = @constCast(@ptrCast(client.options.custom_ciphers)),
        .user_agent = @constCast(@ptrCast(client.options.custom_user_agent)),
        .cookies = @constCast(@ptrCast(client.options.custom_cookies)),
    };

    const res = C.domainRequest(config);
    defer std.c.free(res.ptr);
    if (res.error_code != 0) {
        return Error.CurlError;
    }
    const zig_string = std.mem.span(res.ptr);
    return .{
        .status_code = res.response_status_code,
        .response = zig_string,
    };
}
