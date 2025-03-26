const std = @import("std");

pub fn SplayTree(comptime T: type) type {
    return struct {
        const Self = @This();

        root: ?*Node,

        pub const Node = struct {
            parent: ?*Node,
            left: ?*Node,
            right: ?*Node,
            value: T,
        };

        pub fn init() Self {
            return .{
                .root = null,
            };
        }

        pub fn insert(self: *Self, newNode: *Node) void {
            var current = self.root;
            var parent: ?*Node = null;

            while (current) |node| {
                parent = node;

                if (newNode.value.compare(node.value) < 0) {
                    current = node.left;
                } else {
                    current = node.right;
                }
            }

            newNode.parent = parent;

            if (parent) |p| {
                if (newNode.value.compare(p.value) < 0) {
                    p.left = newNode;
                } else {
                    p.right = newNode;
                }
            } else {
                self.root = newNode;
            }

            splay(newNode);
        }

        pub fn remove(self: *Self, target: *Node) void {
            splay(target);

            const left_subtree = target.left;
            const right_subtree = target.right;

            if (left_subtree) |left| left.parent = null;
            if (right_subtree) |right| right.parent = null;

            if (left_subtree) |left| {
                var max = left;

                while (max.right) |right| {
                    max = right;
                }

                splay(max);

                max.right = right_subtree;

                if (right_subtree) |right| {
                    right.parent = max;
                }

                self.root = max;
            } else {
                self.root = right_subtree;
            }
        }

        pub fn getMin(self: *Self) ?*Node {
            var current = self.root;

            while (current != null and current.?.left != null) {
                current = current.?.left;
            }

            return current;
        }

        pub fn getMax(self: *Self) ?*Node {
            var current = self.root;

            while (current != null and current.?.right != null) {
                current = current.?.right;
            }

            return current;
        }

        fn rotateLeft(node: *Node) void {
            var pivot = node.right.?;

            node.right = pivot.left;

            if (pivot.left) |left| {
                left.parent = node;
            }

            pivot.parent = node.parent;

            if (node.parent) |p| {
                if (node == p.left) {
                    p.left = pivot;
                } else {
                    p.right = pivot;
                }
            }

            pivot.left = node;
            node.parent = pivot;
        }

        fn rotateRight(node: *Node) void {
            var pivot = node.left.?;

            node.left = pivot.right;

            if (pivot.right) |right| {
                right.parent = node;
            }

            pivot.parent = node.parent;

            if (node.parent) |p| {
                if (node == p.left) {
                    p.left = pivot;
                } else {
                    p.right = pivot;
                }
            }

            pivot.right = node;
            node.parent = pivot;
        }

        fn splay(node: *Node) void {
            while (node.parent) |parent| {
                if (parent.parent) |grandparent| {
                    if ((parent.left == node) == (grandparent.left == parent)) {
                        if (parent.left == node) {
                            rotateRight(grandparent);
                            rotateRight(parent);
                        } else {
                            rotateLeft(grandparent);
                            rotateLeft(parent);
                        }
                    } else {
                        if (parent.left == node) {
                            rotateRight(parent);
                            rotateLeft(grandparent);
                        } else {
                            rotateLeft(parent);
                            rotateRight(grandparent);
                        }
                    }
                } else {
                    if (parent.left == node) {
                        rotateRight(parent);
                    } else {
                        rotateLeft(parent);
                    }
                }
            }
        }
    };
}
