const std = @import("std");
const SelectionList = @import("azul.zig").SelectionList;

const Buffer = @import("buffer.zig").Buffer;

pub const Editor = struct {
    bufferList: SelectionList(Buffer),

    /// Called once by the editor to create the editing world
    /// if failed, we cannot call any world procedures
    /// creates one empty (scratch?) buffer
    pub fn init(allocator: std.mem.Allocator) !Editor {
        var bufferList = SelectionList(Buffer).init(allocator);

        // TODO: attempt to restore previous session?

        const scratchBuffer = try Buffer.init(allocator, "<scratch>");

        try bufferList.addFirst(scratchBuffer);
        _ = try bufferList.selectFirst();

        return .{
            .bufferList = bufferList,
        };
    }

    /// The end of the world as we know it
    /// terminates all state information
    /// init must be called again before world procedures can be called again
    pub fn deinit(self: *Editor) !void {
        try self.bufferList.deinit();
    }
};
