const std = @import("std");

const TreeError = error {

};

pub fn SplayTree(comptime T: type) type {
    return struct {
        const Self = @This();

        root: ?*Node,

        allocator: std.mem.Allocator,

        const Node = struct {
            parent: ?*Node,
            left: ?*Node,
            right: ?*Node,
            value: T,
        };

        pub fn init(allocator: std.mem.Allocator) T {
            return .{
                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) void {
            _ = self;
        }

        pub fn insert(self: *Self, value: T) void {
            _ = self;
            _ = value;
        }

        pub fn remove(self: *Self, value: T) *Node {
            _ = self;
            _ = value;
        }

        pub fn getMin(self: *Self) *Node {
            _ = self;
        }

        pub fn getMax(self: *Self) *Node {
            _ = self;
        }

        fn rotateLeft(node: *Node) void {
            _ = node;
        }

        fn rotateRight(node: *Node) void {
            _ = node;
        }

        fn splay(node: *Node) void {
            _ = node;
        }
    };
}
