const std = @import("std");
const SelectionList = @import("azul.zig").SelectionList;

const ImplementationError = error {
    NotYetImplemented,
};

const BufferError = error {
    NameCollision,
    NoSuchBuffer,
    ModifyingScratchBuffer,
    UseOfNullValue,
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

    pub fn bufferCount(self: *Editor) usize {
        return self.bufferList.length;
    }

    pub fn bufferGetByName(self: *Editor, name: []const u8) !*Buffer {
        var it = self.bufferList.iterator();

        var bufferWithName: *Buffer = undefined;

        while (it.hasNext()) {
            bufferWithName = try it.next();
            if (std.mem.eql(u8, name, bufferWithName.name)) {
                return bufferWithName;
            }
        }

        return BufferError.NoSuchBuffer;
    }

    /// Creates an empty buffer with the given name
    /// no two buffers can share the same name
    // use setBufferNext????
    pub fn bufferCreate(self: *Editor, name: []const u8) !void {
        // TODO: verify no name collisions

        const newBuffer = try Buffer.init(self.allocator, name);

        try self.bufferList.addFirst(newBuffer);
    }

    /// remove all characters (and marks?) from the specified buffer
    pub fn bufferClear(self: *Editor, name: []const u8) !void {
        const bufferWithName = self.bufferGetByName(name);
        if (bufferWithName) |buffer| {
            buffer.clear();
            // buffer.markTree.clear();

            return;
        }

        return BufferError.NoSuchBuffer;
    }

    /// Delete specified buffer, setting the next in the chain to current
    /// if no next, re-create scratch buffer and set it to current
    pub fn bufferDelete(self: *Editor, name: []const u8) !void {
        var it = self.bufferList.iterator();

        var bufferWithName: *Buffer = undefined;

        while (it.hasNext()) {
            bufferWithName = try it.next();
            if (std.mem.eql(u8, name, bufferWithName.name)) {
                _ = try it.remove();

                return;
            }
        }

        return BufferError.NoSuchBuffer;
    }

    /// Set to specified buffer to active
    pub fn bufferSetCurrent(self: *Editor, name: []const u8) !void {
        var it = self.bufferList.iterator();

        var bufferWithName: *Buffer = undefined;

        while (it.hasNext()) {
            bufferWithName = try it.next();
            if (std.mem.eql(u8, name, bufferWithName.name)) {
                _ = try it.select();

                return;
            }
        }

        return BufferError.NoSuchBuffer;
    }

};
