const std = @import("std");

const Editor = @import("editor.zig").Editor;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const editor = try Editor.init(allocator);

    const head = editor.bufferList.head;

    std.debug.print("{s}", head.?.value);
}
