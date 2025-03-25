const std = @import("std");

const Editor = @import("editor.zig").Editor;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var editor = try Editor.init(allocator);

    var head = try editor.bufferList.getFirst();

    try editor.bufferCreate("TEST");
    head = try editor.bufferList.getFirst();
    std.debug.print("{s}: {s}\n", .{ head.name, head.contents });
    try editor.bufferClear("TEST");
    head = try editor.bufferList.getFirst();
    std.debug.print("{s}: {s}\n", .{ head.name, head.contents });


}
