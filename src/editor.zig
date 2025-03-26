const std = @import("std");

const SelectionList = @import("azul.zig").SelectionList;
const Location = @import("location.zig").Location;

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

        while (it.hasNext()) {
            if (std.mem.eql(u8, name, (try it.next()).name)) {
                _ = try it.remove();

                return;
            }
        }

        // TODO: if no next, re-create scratch buffer and set it to current

        return BufferError.NoSuchBuffer;
    }

    /// Set to specified buffer to active
    pub fn bufferSetCurrent(self: *Editor, name: []const u8) !void {
        var it = self.bufferList.iterator();

        while (it.hasNext()) {
            if (std.mem.eql(u8, name, (try it.next()).name)) {
                _ = try it.select();

                return;
            }
        }

        return BufferError.NoSuchBuffer;
    }

    /// Set buffer to the next in the chain and return the (name?id) of the new one
    pub fn bufferSetNext(self: *Editor) ![]const u8 {
        return (try self.bufferList.selectNext()).name;
    }

    /// Rename the current buffer
    pub fn bufferRenameCurrent(self: *Editor, name: []const u8) !void {
        // TODO: verifiy not scratch buffer

        (try self.bufferList.getSelected()).name = name;
    }

    /// Get the name of the current buffer
    pub fn bufferGetCurrentName(self: *Editor) ![]const u8 {
        return (try self.bufferList.getSelected()).name;
    }

    /// Set the point to the specified location
    pub fn pointSet(self: *Editor, location: Location) !void {
        (try self.bufferList.getSelected()).point = location;
    }

    /// Move point forward n chars
    pub fn pointMoveForward(self: *Editor, n: usize) !void {
        const currentCount = self.locationToCount(self.pointGetLocation());

        (try self.bufferList.getSelected()).point = self.countToLocation(currentCount + n);
    }

    /// Move point backward n chars
    pub fn pointMoveBackward(self: *Editor, n: usize) !void {
        const currentCount = self.locationToCount(self.pointGetLocation());

        (try self.bufferList.getSelected()).point = self.countToLocation(currentCount - n);
    }

    pub fn pointGetLocation(self: *Editor) !Location {
        return (try self.bufferList.getSelected()).point;
    }

    /// Get the line number that the point is on
    pub fn pointGetLine(self: *Editor) !usize {
        return (try self.bufferList.getSelected()).currentLine;
    }

    /// Return point to the start of the buffer
    pub fn pointMoveBufferStart(self: *Editor) !Location {
        (try self.bufferList.getSelected()).point = self.countToLocation(0);

        return self.pointGetLocation();
    }

    /// Move point to the end of the buffer
    pub fn pointMoveBufferEnd(self: *Editor) !Location {
        var currentBuffer = (try self.bufferList.getSelected());
        currentBuffer = self.countToLocation(currentBuffer.?.numChars);

        return self.pointGetLocation();
    }

    /// Returns 0 if same location, 1 if l1 after 12, else -1
    pub fn compareLocations(self: *Editor, l1: Location, l2: Location) i32 {
        _ = self;

        return l1.compare(l2);
    }

    /// Converts a Location to the number of characters between start and location
    pub fn locationToCount(self: *Editor, location: Location) !usize {
        const cbuff = (try self.bufferList.getSelected());

        return if (location.pos < cbuff.gapStart) location.pos
               else location.pos + (cbuff.gapEnd - cbuff.gapStart);
    }

    /// Converts a count (absolute position) to a location
    pub fn countToLocation(self: *Editor, count: usize) !Location {
        const cbuff = (try self.bufferList.getSelected());

        return if (count < cbuff.gapStart) .{ .pos = count }
               else .{ .pos = count + (cbuff.gapEnd - cbuff.gapStrat) };
    }


};
