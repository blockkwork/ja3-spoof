const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "examples",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const ja3_spoof = b.dependency("ja3_spoof", .{}).module("ja3_spoof");
    exe.root_module.addImport("ja3_spoof", ja3_spoof);

    b.installArtifact(exe);
}
