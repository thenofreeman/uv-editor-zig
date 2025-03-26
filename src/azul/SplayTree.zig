const std = @import("std");

const TreeError = error {

};

pub fn SplayTree(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) T {
            return .{
                .allocator = allocator,
            };
        }
    };
}
