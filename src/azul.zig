const std = @import("std");

const ListError = error {
    EmptyListError,
    BadListIndexError,
    UnknownError,
    BadNode,
    NoSelectionMade,
};

pub fn SelectionList(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            value: T,
            prev: ?*Node,
            next: ?*Node,
        };

        head: ?*Node,
        tail: ?*Node,
        active: ?*Node,
        length: usize,

        allocator: std.mem.Allocator,

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .head = null,
                .tail = null,
                .active = null,
                .length = 0,

                .allocator = allocator,
            };
        }

        pub fn deinit(self: *Self) !void {
            try self.clear();
        }

        pub fn clear(self: *Self) !void {
            var next = self.head.next;

            while (self.head != null) {
                try self.allocator.destroy(self.head);
                self.head = next;
                next = next.?.next;
            }

            self.head = null;
            self.tail = null;
            self.active = null;
        }

        pub fn size(self: *Self) u32 {
            return self.length;
        }

        pub fn isEmpty(self: *Self) bool {
            return self.list.size() != 0;
        }

        pub fn addIndex(self: *Self, value: T, index: usize) !void {
            const nodeToShift = try self.getNodeAtIndex(index);

            try self.addNode(value, nodeToShift);
        }

        pub fn addFirst(self: *Self, value: T) !void {
            self.head = try self.addNode(value, self.head);
        }

        pub fn addLast(self: *Self, value: T) !void {
            self.tail = try self.addNode(value, self.tail);
        }

        pub fn addPrev(self: *Self, value: T) !void {
            _ = try self.addNode(value, self.active);
        }

        pub fn addNext(self: *Self, value: T) !void {
            _ = try self.addNode(value, self.active.next);
        }

        pub fn selectIndex(self: *Self, index: usize) !T {
            self.active = try self.getNodeAtIndex(index);

            return try self.getSelected();
        }

        pub fn selectPrev(self: *Self) !T {
            if (self.isEmpty()) {
                return ListError.EmptyListError;
            }

            self.active = self.active.?.prev;

            return try self.getSelected();
        }

        pub fn selectNext(self: *Self) !T {
            if (self.isEmpty()) {
                return ListError.EmptyListError;
            }

            self.active = self.active.?.next;

            return try self.getSelected();
        }

        pub fn selectFirst(self: *Self) !T {
            self.active = self.head;

            return try self.getSelected();
        }

        pub fn selectLast(self: *Self) !T {
            self.active = self.tail;

            return try self.getSelected();
        }

        pub fn getSelected(self: *Self) !T {
            if (self.active) |active| {
                return active.value;
            }

            return ListError.NoSelectionMade;
        }

        pub fn getAtIndex(self: *Self, index: usize) !T {
            const nodeAtIndex = try self.getNodeAtIndex(index);

            return nodeAtIndex.value;
        }

        pub fn getFirst(self: *Self) !T {
            if (self.head) |head| {
                return head.value;
            }

            return ListError.EmptyListError;
        }

        pub fn getLast(self: *Self) !T {
            if (self.tail) |tail| {
                return tail.value;
            }

            return ListError.EmptyListError;
        }

        pub fn removeSelected(self: *Self) !T {
            return try self.removeNode(self.active);
        }

        pub fn removeAtIndex(self: *Self, index: usize) !T {
            return try self.removeNode(try self.getNodeAtIndex(index));
        }

        pub fn removeFirst(self: *Self) !T {
            return try self.removeNode(self.head);
        }

        pub fn removeLast(self: *Self) !T {
            return try self.removeNode(self.tail);
        }

        fn addNode(self: *Self, value: T, nodeToShift: ?*Node) !*Node {
            const newNode = try self.allocator.create(Node);
            errdefer self.allocator.destroy(newNode);

            if (nodeToShift) |node| {
                newNode.* = Node {
                    .next = node,
                    .prev = node.prev,
                    .value = value,
                };

                node.prev = newNode;
            } else {
                newNode.* = Node {
                    .next = newNode,
                    .prev = newNode,
                    .value = value,
                };

                self.head = newNode;
                self.tail = newNode;
            }

            self.length += 1;

            return newNode;
        }

        fn removeNode(self: *Self, nodeToRemove: ?*Node) !Node {
            if (nodeToRemove) |node| {
                node.prev.next = node.next;
                node.next.prev = node.prev;

                self.allocator.destroy(nodeToRemove);

                self.length -= 1;

                return node;
            }

            return ListError.BadNode;
        }

        fn getNodeAtIndex(self: *Self, index: usize) !*Node {
            if (!self.isIndexWithinBounds(index)) {
                return ListError.BadListIndexError;
            }

            var current = self.head;

            var i: usize = 0;
            while (i < index) : (i += 1) {
                current = current.?.next;
            }

            return current.?;
        }

        fn isIndexWithinBounds(self: *Self, index: usize) bool {
            return (index > 0) and (index <= self.length);
        }
    };
}
