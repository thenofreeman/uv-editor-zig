const std = @import("std");

const ListError = error {
    EmptyListError,
    BadListIndexError,
    UnknownError,
    BadNode,
    NoSelectionMade,
};

/// A Circular Doubly-Linked List with an Active Node
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
            return self.length == 0;
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

        pub fn selectIndex(self: *Self, index: usize) !*T {
            self.active = try self.getNodeAtIndex(index);

            return try self.getSelected();
        }

        pub fn selectPrev(self: *Self) ?*T {
            if (self.active) |active| {
                self.active = active.prev;

                return self.getSelected();
            }

            return null;
        }

        pub fn selectNext(self: *Self) ?*T {
            if (self.active) |active| {
                self.active = active.next;

                return self.getSelected();
            }

            return null;
        }

        pub fn selectFirst(self: *Self) ?*T {
            self.active = self.head;

            return self.getSelected();
        }

        pub fn selectLast(self: *Self) ?*T {
            self.active = self.tail;

            return self.getSelected();
        }

        pub fn getSelected(self: *Self) ?*T {
            if (self.active) |active| {
                return &active.value;
            }

            return null;
        }

        pub fn getAtIndex(self: *Self, index: usize) !*T {
            const nodeAtIndex = try self.getNodeAtIndex(index);

            return nodeAtIndex.value;
        }

        pub fn getFirst(self: *Self) !*T {
            if (self.head) |head| {
                return head.value;
            }

            return ListError.EmptyListError;
        }

        pub fn getLast(self: *Self) !*T {
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
            var newNode = try self.allocator.create(Node);
            errdefer self.allocator.destroy(newNode);

            newNode.* = Node {
                .next = null,
                .prev = null,
                .value = value,
            };

            if (self.isEmpty()) {
                newNode.next = newNode;
                newNode.prev = newNode;

                self.head = newNode;
                self.tail = newNode;
            } else {
                newNode.next = nodeToShift;
                newNode.prev = nodeToShift.?.prev;

                nodeToShift.?.prev = newNode;
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

        pub fn iterator(self: *Self) Iterator {
            return Iterator {
                .current = null,
                .nextIndex = 1,
                .list = self,
            };
        }

        pub const Iterator = struct {
            current: ?*Node,
            nextIndex: usize,
            list: *SelectionList(T),

            pub fn hasNext(self: *Iterator) bool {
                return self.nextIndex < self.list.length;
            }

            pub fn next(self: *Iterator) !*T {
                if (!self.hasNext()) {
                    return ListError.BadListIndexError;
                }

                if (self.current == null) {
                    self.current = self.list.head;
                } else {
                    self.current = self.current.?.next;
                }

                self.nextIndex += 1;

                return &self.current.?.value;
            }

            pub fn remove(self: *Iterator) !T {
                if (self.current) |current| {
                    current.prev.?.next = current.next;
                    current.next.?.prev = current.prev;

                    std.debug.print("REMOVEME: {s}\n", .{ current.value.name });

                    self.list.allocator.destroy(current);

                    const removedValue = current.value;
                    self.current = current.next;

                    self.list.length -= 1;
                    self.nextIndex -= 1;

                    return removedValue;
                }

                return ListError.EmptyListError;
            }

            pub fn select(self: *Iterator) !*T {
                if (self.current) |current| {
                    self.list.active = current;

                    return &current.value;
                }

                return ListError.EmptyListError;
            }
        };

        fn isIndexWithinBounds(self: *Self, index: usize) bool {
            return (index > 0) and (index <= self.length);
        }
    };
}
