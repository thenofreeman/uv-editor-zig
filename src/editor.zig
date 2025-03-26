const std = @import("std");

const azul = @import("azul.zig");

const Location = @import("location.zig").Location;

const Mark = @import("mark.zig").Mark;
const MarkNode = azul.SplayTree(Mark).Node;

const ImplementationError = error {
    NotYetImplemented,
};

const BufferError = error {
    NameCollision,
    NoSuchBuffer,
    ModifyingScratchBuffer,
    UseOfNullValue,
    UnnamedError,
};

const Buffer = @import("buffer.zig").Buffer;

pub const Editor = struct {
    bufferList: azul.SelectionList(Buffer),

    allocator: std.mem.Allocator,

    /// Called once by the editor to create the editing world
    /// if failed, we cannot call any world procedures
    /// creates one empty (scratch?) buffer
    pub fn init(allocator: std.mem.Allocator) !Editor {
        var bufferList = azul.SelectionList(Buffer).init(allocator);

        // TODO: attempt to restore previous session?

        const scratchBuffer = try Buffer.init(allocator, "<scratch>");

        try bufferList.addFirst(scratchBuffer);
        _ = bufferList.selectFirst();

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
    pub fn bufferSetNext(self: *Editor) []const u8 {
        return self.bufferList.selectNext().?.name;
    }

    /// Rename the current buffer
    pub fn bufferRenameCurrent(self: *Editor, name: []const u8) void {
        // TODO: verifiy not scratch buffer

        self.bufferList.getSelected().?.name = name;
    }

    /// Get the name of the current buffer
    pub fn bufferGetCurrentName(self: *Editor) []const u8 {
        return self.bufferList.getSelected().?.name;
    }

    /// Set the point to the specified location
    pub fn pointSet(self: *Editor, location: Location) void {
        self.bufferList.getSelected().?.point = location;
    }

    /// Move point forward n chars
    pub fn pointMoveForward(self: *Editor, n: usize) void {
        const currentCount = self.locationToCount(self.pointGetLocation());

        self.pointSet(self.countToLocation(currentCount + n));
    }

    /// Move point backward n chars
    pub fn pointMoveBackward(self: *Editor, n: usize) void {
        const currentCount = self.locationToCount(self.pointGetLocation());

        self.pointSet(self.countToLocation(currentCount - n));
    }

    pub fn pointGetLocation(self: *Editor) Location {
        return self.bufferList.getSelected().?.point;
    }

    /// Get the line number that the point is on
    pub fn pointGetLine(self: *Editor) usize {
        return self.bufferList.getSelected().?.currentLine;
    }

    /// Return point to the start of the buffer
    pub fn pointMoveBufferStart(self: *Editor) Location {
        self.bufferList.getSelected().?.point = self.countToLocation(0);

        return self.pointGetLocation();
    }

    /// Move point to the end of the buffer
    pub fn pointMoveBufferEnd(self: *Editor) Location {
        const cbuff = self.bufferList.getSelected().?;

        self.pointSet(self.countToLocation(cbuff.numChars));

        return self.pointGetLocation();
    }

    /// Returns 0 if same location, 1 if l1 after 12, else -1
    pub fn compareLocations(self: *Editor, l1: Location, l2: Location) i32 {
        _ = self;

        return l1.compare(l2);
    }

    /// Converts a Location to the number of characters between start and location
    pub fn locationToCount(self: *Editor, location: Location) usize {
        const cbuff = self.bufferList.getSelected().?;

        return if (location.pos < cbuff.gapStart) location.pos
                else location.pos + (cbuff.gapEnd - cbuff.gapStart);
    }

    /// Converts a count (absolute position) to a location
    pub fn countToLocation(self: *Editor, count: usize) Location {
        const cbuff = self.bufferList.getSelected().?;

        var adjustedCount = count;

        if (count > cbuff.numChars) {
            adjustedCount = cbuff.numChars;
        }

        return if (adjustedCount >= cbuff.gapStart) .{ .pos = adjustedCount }
               else .{ .pos = adjustedCount - (cbuff.gapEnd - cbuff.gapStart) };
    }

    // Get the pecentage of the point within in the buffer
    // ie. how far in the file is it
    pub fn pointPercentInBuffer(self: *Editor) f32 {
        return @as(f32, @floatFromInt(locationToCount(self.bufferList.getSelected().?.point))) * 100.0
                / @as(f32, @floatFromInt(self.getNumChars()));
    }

    /// Create a mark of fix-type at current point position
    /// and return it
    pub fn markCreate(self: *Editor, isFixed: bool) !*MarkNode {
        var newMarkNode = try self.allocator.create(azul.SplayTree(Mark).Node);

        newMarkNode.value = Mark {
            .point = self.pointGetLocation(),
            .isFixed = isFixed,
        };

        self.bufferList.getSelected().?.markTree.insert(newMarkNode);

        return newMarkNode;
    }

    /// delete specified mark
    pub fn markDelete(self: *Editor, markNodeToDelete: *MarkNode) !void {
        const markToDeleteNode = self.markTree.remove(markNodeToDelete);

        try self.allocator.destroy(markToDeleteNode);
    }

    /// Set a mark to current point
    pub fn markMoveToPoint(self: *Editor, markNode: *MarkNode) void {
        self.markSetLocation(markNode, self.pointGetLocation());
    }

    /// Set current point to the location of the specified mark
    pub fn pointMoveToMark(self: *Editor, markNode: *MarkNode) void {
        self.pointSet(self.markGetLocation(markNode));
    }

    /// Return the location of the mark
    pub fn markGetLocation(self: *Editor, markNode: *MarkNode) Location {
        _ = self;

        return markNode.value.point;

    }

    /// Move mark to location
    pub fn markSetLocation(self: *Editor, markNode: *MarkNode, location: Location) void {
        _ = self;

        markNode.value.point = location;
    }

    /// True if point is at the specified mark
    pub fn isPointAtMark(self: *Editor, markNode: *MarkNode) bool {
        return 0 == self.pointGetLocation().compare(self.markGetLocation(markNode));
    }

    /// True if point is before specified mark
    pub fn isPointBeforeMark(self: *Editor, markNode: *MarkNode) bool {
        return -1 == self.pointGetLocation().compare(self.markGetLocation(markNode));
    }

    /// True if point is after specified mark
    pub fn isPointAfterMark(self: *Editor, markNode: *MarkNode) bool {
        return 1 == self.pointGetLocation().compare(self.markGetLocation(markNode));
    }

    /// Swap postitions of point and specified mark
    pub fn swapPointAndMark(self: *Editor, markNode: *MarkNode) void {
        const pointLocation = self.pointGetLocation();
        const markLocation = self.markGetLocation(markNode);

        self.pointSet(markLocation);
        self.markSetLocation(markNode, pointLocation);
    }

    /// Get char at point
    /// error if at end of buffer
    pub fn getChar(self: *Editor) u8 {
        self.bufferList.getSelected().?.contents[self.pointGetLocation().pos];
    }

    /// Return n characters as a string starting at the point
    /// return less than n if buffer end is reached first
    pub fn getString(self: *Editor, n: usize) []const u8 {
        const start = self.pointGetLocation().pos;

        var end = start + n;

        const trailingChars = self.getNumChars() - start;

        if (n > trailingChars) {
            end = start + trailingChars;
        }

        return self.bufferList.getSelected().?.contents[start..end];
    }

    /// Return the number of characters in the buffer
    pub fn getNumChars(self: *Editor) usize {
        return self.bufferList.getSelected().?.numChars;
    }

    /// Return the number of lines in the buffer
    /// [should count an incomplete last line??]
    pub fn getNumLines(self: *Editor) usize {
        return self.bufferList.getSelected().?.numLines;
    }

};
