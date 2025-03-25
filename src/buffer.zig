const std = @import("std");

pub const Buffer = struct {
    name: []const u8,

    // gapStart: usize,
    // gapEnd: usize,

    // point: Location,

    // currentLine: usize,

    // numChars: usize,
    // numLines: usize,

    // markTree: AVLTree(Mark),

    contents: []const u8, // Storage

    // fileName: []const u8,
    // fileTime: u64,

    // isModified: bool,

    // modeList: *Mode,

    pub fn init(allocator: std.mem.Allocator, name: []const u8) !Buffer {
        _ = allocator;

        // TODO: load data from file
        // TODO: restore previous buffer positional data (line, point, etc)

        return .{
            .name = name,
            .contents = "THIS IS A TEST!",
        };
    }

    pub fn clear(self: *Buffer) void {
        std.debug.print("MATCH FOUND\n", .{});
        self.contents = "";
    }
};
