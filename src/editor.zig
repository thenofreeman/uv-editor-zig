const std = @import("std");
const SelectionList = @import("azul.zig").SelectionList;

const ImplementationError = error {
    NotYetImplemented,
};

const Buffer = @import("buffer.zig").Buffer;

pub const Editor = struct {
    bufferList: SelectionList(Buffer),

    allocator: std.mem.Allocator,

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
            .allocator = allocator,
        };
    }

    /// The end of the world as we know it
    /// terminates all state information
    /// init must be called again before world procedures can be called again
    pub fn deinit(self: *Editor) !void {
        try self.bufferList.deinit();
    }

    /// Save the world state to a file
    pub fn save(self: *Editor, filename: []const u8) !void {
        _ = self;
        _ = filename;

        return ImplementationError.NotYetImplemented;
    }

    /// Load the world state from a file
    /// TODO: should this be in World???? or outside
    pub fn load(filename: []const u8) !void {
        _ = filename;

        return ImplementationError.NotYetImplemented;
    }

    pub fn bufferCreate(self: *Editor, name: []const u8) !void {
        // TODO: verify no name collisions

        const newBuffer = Buffer.init(self.allocator, name);
        // errdefer newBuffer.deinit();

        self.bufferList.addFirst(&newBuffer);
    }

};
