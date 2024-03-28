const std = @import("std");

const SUB_DIR = "ja3_lib";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addModule("ja3_spoof", .{
        .root_source_file = .{ .path = "src/Client.zig" },
        .target = target,
        .optimize = optimize,
    });

    lib.addIncludePath(.{ .path = SUB_DIR ++ "/." });
    lib.addIncludePath(.{ .path = SUB_DIR ++ "/src" });
    lib.addIncludePath(.{ .path = SUB_DIR ++ "/src/c" });

    lib.addCSourceFile(.{
        .file = std.Build.LazyPath.relative(SUB_DIR ++ "/src/c/url.c"),
        .flags = &[_][]const u8{"-lcurl"},
    });

    lib.addIncludePath(std.Build.LazyPath.relative("src"));

    lib.linkSystemLibrary("c", .{});
    lib.linkSystemLibrary("libcurl", .{});
}
