const std = @import("std");
const SelectionList = @import("azul.zig").SelectionList(u8);

// const Editor = @import("editor.zig").Editor;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var sl = SelectionList.init(allocator);
    try sl.addFirst(10);
    try sl.addFirst(20);
    try sl.addFirst(30);
    try sl.addFirst(40);
    try sl.addFirst(50);

    const first = try sl.getFirst();
    const last = try sl.getLast();
    const middle = try sl.getAtIndex(2);

    std.debug.print("{d}\n", .{ first });
    std.debug.print("{d}\n", .{ middle });
    std.debug.print("{d}\n", .{ last });

    // const editor = Editor.init(allocator);
}
