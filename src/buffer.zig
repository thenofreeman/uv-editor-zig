const std = @import("std");

const azul = @import("azul.zig");

const Location = @import("location.zig").Location;
const Mark = @import("mark.zig").Mark;

pub const Buffer = struct {
    /// A string name for users to refer to the buffer by
    name: []const u8,

    /// Buffer Gap positions
    gapStart: usize,
    gapEnd: usize,

    /// The current location where edit operations take place.
    point: Location,
    /// Tracks current line position efficiently
    currentLine: usize,

    /// Tracks the buffer total char/line count efficiently
    numChars: usize,
    numLines: usize,

    markTree: azul.SplayTree(Mark),

    contents: []const u8, // Storage

    // Name of the file on disk. Empty string if none yet given
    // fileName: []const u8,
    // The last time in which the buffer and the associated file were identical
    // Helps determine if a file was altered by another process (ie editing out of sync)
    // fileTime: u64,
    // Has the editor modifed the buffer since it was last written or read
    // isModified: bool,

    // List of active modes
    // Must be sorted
    // modeList: *Mode,

    pub fn init(allocator: std.mem.Allocator, name: []const u8) !Buffer {
        _ = allocator;

        // TODO: load data from file
        // TODO: restore previous buffer positional data (line, point, etc)

        return .{
            .name = name,
            .contents = "THIS-IS-A-TEST!",
            .point = Location.init(),
            .currentLine = 0,
            .gapStart = 0,
            .gapEnd = 1,
            .numChars = 15,
            .numLines = 1,
            .markTree = azul.SplayTree(Mark).init(),
        };
    }

    pub fn clear(self: *Buffer) void {
        self.contents = "";
    }
};
