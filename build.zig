const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addModule("ja3_spoof", .{
        .root_source_file = .{ .path = "src/Client.zig" },
        .target = target,
        .optimize = optimize,
    });

    lib.addIncludePath(.{ .path = "." });
    lib.addIncludePath(.{ .path = "src" });
    lib.addIncludePath(.{ .path = "src/c" });

    lib.addCSourceFile(.{
        .file = std.Build.LazyPath.relative("src/c/url.c"),
        .flags = &[_][]const u8{"-lcurl"},
    });

    lib.addIncludePath(std.Build.LazyPath.relative("src"));

    lib.linkSystemLibrary("c", .{});
    lib.linkSystemLibrary("libcurl", .{});
}
