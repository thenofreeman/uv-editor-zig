const std = @import("std");

// notes:
// -- consider using ids for buffers (get by id, set by id..)?

const World = struct {
    bufferList: *Buffer,
    currentBuffer: *Buffer,

    /// Called once by the editor to create the editing world
    /// if failed, we cannot call any world procedures
    /// creates one empty (scratch?) buffer
    /// attempts to restore previous session?
    pub fn init(allocator: std.mem.Allocator) !World {
        _ = allocator;

        return . {

        };
    }

    /// The end of the world as we know it
    /// terminates all state information
    /// init must be called again before world procedures can be called again
    pub fn deinit(self: *World) !void {
        _ = self;

    }

    /// Save the world state to a file
    /// TODO: should this be in World???? or outside
    pub fn save(self: *World, filename: []const u8) !void {
        _ = self;
        _ = filename;

    }

    /// Load the world state from a file
    /// TODO: should this be in World???? or outside
    pub fn load(self: *World, filename: []const u8) !void {
        _ = self;
        _ = filename;

    }

    /// Creates an empty buffer with the given name
    /// no two buffers can share the same name
    pub fn bufferCreate(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// remove all characters (and marks?) from the specified buffer
    pub fn bufferClear(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Delete specified buffer, setting the next in the chain to current
    /// if no next, re-create scratch buffer and set it to current
    pub fn bufferDelete(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Set to specified buffer
    pub fn bufferSetCurrent(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Set buffer to the next in the chain and return the (name?id) of the new one
    pub fn bufferSetNext(self: *World) []const u8 {
        _ = self;

    }

    /// Rename the current buffer
    pub fn bufferRenameCurrent(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Get the name of the current buffer
    pub fn bufferGetCurrentName(self: *World) []const u8 {
        _ = self;

    }

    /// Set the point to the specified location
    pub fn pointSet(self: *World, location: Location) !void {
        _ = self;
        _ = location;

    }

    /// Move point forward n chars
    pub fn pointMoveForward(self: *World, n: usize) !void {
        _ = self;
        _ = n;

    }

    /// Move backward n chars
    pub fn pointMoveBackward(self: *World, n: usize) !void {
        _ = self;
        _ = n;

    }

    pub fn pointGetLocation(self: *World) Location {
        _ = self;

    }

    /// Get the line number that the point is on
    pub fn pointGetLine(self: *World) usize {
        _ = self;

    }

    /// Return point to the start of the buffer
    pub fn pointMoveBufferStart(self: *World) Location {
        _ = self;

    }

    /// Move point to the end of the buffer
    pub fn pointMoveBufferEnd(self: *World) Location {
        _ = self;

    }

    /// Returns 0 if same location, 1 if l1 after 12, else -1
    pub fn compareLocations(self: *World, locat1: Location, locat2: Location) !i32 {
        _ = self;

    }

    /// Converts a Location to the number of characters between start and l
    pub fn locationToCount(self: *World, locat: Location) !usize {
        _ = self;

    }

    /// Converts a count (absolute position) to a location
    pub fn countToLocation(self: *World, count: usize) !Location {
        _ = self;

    }

    // ---
    // Mark Management
    // ---

    /// Create a mark of fix-type (and return its name?) at current point position
    pub fn markCreate(self: *World, name: []const u8, isFixed: bool) ![]const u8 {
        _ = self;
        _ = name;
        _ = isFixed;

    }

    /// delete specified mark
    pub fn markDelete(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Set mark by name to current point
    pub fn markToPoint(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Set current point to the location of the specified mark
    pub fn pointToMark(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Return the location of the mark
    pub fn markGet(self: *World, name: []const u8) !Location {
        _ = self;
        _ = name;

    }

    /// Move mark to location
    pub fn markSet(self: *World, name: []const u8, locat: Location) !void {
        _ = self;
        _ = name;

    }

    /// True if point is at the specified mark
    pub fn isPointAtMark(self: *World, name: []const u8) !bool {
        _ = self;
        _ = name;

    }

    /// True if point is before specified mark
    pub fn isPointBeforeMark(self: *World, name: []const u8) !bool {
        _ = self;
        _ = name;

    }

    /// True if point is after specified mark
    pub fn isPointAfterMark(self: *World, name: []const u8) !bool {
        _ = self;
        _ = name;

    }

    /// Swap postitions of point and specified mark
    pub fn swapPointAndMark(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Get char at point
    /// error if at end of buffer
    pub fn getChar(self: *World) !u8 {
        _ = self;

    }

    /// Return n characters as a string starting at the point
    /// return less than n if buffer end is reached first
    pub fn getString(self: *World, n: usize) ![]const u8 {
        _ = self;
        _ = n;

    }

    /// Return the number of characters in the buffer
    pub fn getNumChars(self: *World) usize {
        return self.currentBuffer.numChars;
    }

    /// Return the number of lines in the buffer
    /// [should count an incomplete last line??]
    pub fn getNumLines(self: *World) usize {
        return self.currentBuffer.numLines;
    }

    /// Get the name assiciated with the current buffer
    pub fn getFileName(self: *World) []const u8 {
        _ = self;

    }

    /// Set the file name for the current buffer
    pub fn setFileName(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// Write the buffer to the named file
    /// convert between internal and external representations
    /// clear the modified flag and update time
    pub fn bufferWrite(self: *World) !void {
        _ = self;

    }

    /// Clear the buffer and read the current named file into it
    /// convert between external and internal representations
    /// clear the modified flag and update time
    pub fn bufferRead(self: *World) !void {
        _ = self;

    }


    /// Inserts contents of filename into the current buffer at point
    /// convert between external and internal representations
    /// set modified flag if inserted file was not empty
    pub fn bufferInsert(self: *World, filename: []const u8) !void {
        _ = self;
        _ = filename;

    }

    /// true if file was changed since last read/written
    pub fn isFileChanged(self: *World) bool {
        _ = self;

    }

    /// Set the state of mod flag
    /// most often used to manually clear the mod flag where user
    /// is sure that any changes should be discarded
    /// set by any insertion, deletion, or changes to buffer
    pub fn setBufferModified(self: *World, modified: bool) void {
        _ = self;
        _ = modified;

    }

    /// Get the value of the mod flag
    pub fn getBufferModified(self: *World) bool {
        self.currentBuffer.isModified;

    }

    /// Append new mode with supplied name and add procedure to mode list
    /// at front determines whether is is added to front or end of chain
    pub fn modeAppend(
        self: *World,
        name: []const u8,
        addProc: fn() TestError.a!void, // TODO: fix inferred error set
        atFront: bool
    ) !void {
        _ = self;
        _ = name;
        _ = addProc;
        _ = atFront;

    }

    /// Remove named mode from mode list
    pub fn modeDelete(self: *World, name: []const u8) !void {
        _ = self;
        _ = name;

    }

    /// invode the add procedures on the mode list, creating a commnad set
    pub fn modeInvoke(self: *World) !void {
        _ = self;

    }

    /// Insert one character at point, set point to inserted char
    pub fn insertChar(self: *World, c: u8) void {
        _ = self;
        _ = c;

    }

    /// Insert a string of chars at point, point placed after the string
    pub fn insertString(self: *World, str: []const u8) void {
        _ = self;
        _ = str;

    }

    /// Replace char at point with another
    /// effectively insert-delete, unless at end of buffer -- just insert
    pub fn replaceChar(self: *World, c: u8) void {
        _ = self;
        _ = c;

    }

    /// Replace a string of characters
    pub fn replaceString(self: *World, str: []const u8) void {
        _ = self;
        _ = str;

    }

    /// Delete a specified number of characters from the buffer
    /// excess is ignored
    pub fn deleteCharsForward(self: *World, n: usize) !void {
        _ = self;
        _ = n;

    }

    /// Delete a specified number of characters from the buffer
    /// excess is ignored
    pub fn deleteCharsBackward(self: *World, n: usize) !void {
        _ = self;
        _ = n;

    }

    /// Remove all chars between point and mark
    pub fn deleteRegion(self: *World, markName: []const u8) !void {
        _ = self;
        _ = markName;

    }

    /// Copy all chars between point and the mark to a special buffer (inserting at point)
    pub fn copyRegion(self: *World, markName: []const u8) !void {
        _ = self;
        _ = markName;

    }

    /// Searches for the first occurance of str after point
    /// if found leave the point at the end of the found str
    /// point is not moved if not found
    pub fn searchForward(self: *World, str: []const u8) !void {
        _ = self;
        _ = str;

    }

    /// Searches for the first occurance of str before point
    /// if found leave the point at the start of the found str
    /// point is not moved if not found
    pub fn searchBackward(self: *World, str: []const u8) !void {
        _ = self;
        _ = str;

    }

    /// True if str matches contents of buffer starting at point
    /// ie. true if searchForward would move point str.len chars forward
    pub fn isMatch(self: *World, str: []const u8) bool {
        _ = self;
        _ = str;

    }

    /// Find first occurance of any char in the supplied string
    /// and place cursor before char after point
    /// leave point at end of buffer if no chars in str are found
    pub fn findFirstInForward(self: *World, str: []const u8) !void {
        _ = self;
        _ = str;

    }

    /// Similar to findFirstInForward
    pub fn findFirstInBackward(self: *World, str: []const u8) !void {
        _ = self;
        _ = str;

    }

    /// Searches for the first occurance of any character not in str
    /// and place cursor before non-str char after point
    /// leave point at end of buffer if (no) char in string is found
    pub fn findFirstNotInForward(self: *World, str: []const u8) !void {
        _ = self;
        _ = str;

    }

    /// Similar to findFirstNotInForward
    pub fn findFirstNotInBackward(self: *World, str: []const u8) !void {
        _ = self;
        _ = str;

    }

    /// Retruns the zero-origin column that point is in
    /// -- take into account tab stop, var-width vars, special chars
    /// -- dont account for screen width (width shouldn't affect action of edit commands)
    pub fn getColumn(self: *World) usize {
        _ = self;

    }

    /// Move the point to the desired column
    /// stop at line end if col is greater than length
    /// specified col may not be reachable due to special chars or tab-stops
    /// if specified col cannot be exactly reached, use the round flag
    /// if round flag is set: point is rounded to nearest available col
    ///    else point is moved to the next highest available column
    pub fn setColumn(self: *World, col: usize, round: bool) void {
        _ = self;
        _ = col;
        _ = round;

    }

};

const max_name_size = 100;

const Buffer = struct {
    /// A pointer for a circular list of buffers
    /// -- circular because there is no specific origin buffer
    nextBuffer: *Buffer,
    /// A string name for users to refer to the buffer by
    bufferName: []const u8,

    /// The current location where edit operations take place.
    point: Location,
    /// Tracks current line position efficiently
    currentLine: usize,
    /// Tracks the buffer length/size efficiently
    numChars: usize,
    /// Tracts total number of lines efficiently
    numLines: usize,

    /// A linked list (non-circular) of marks corresponding to positions in the buffer
    /// sorted by position in buffer
    /// null indicates empty list
    markList: ?*Mark,

    /// Actual buffer contents
    contents: Storage,

    /// Name of the file on disk. Empty string if none yet given
    fileName: []const u8,
    /// The last time in which the buffer and the associated file were identical
    /// Helps determine if a file was altered by another process (ie editing out of sync)
    fileTime: u64,
    /// Has the editor modifed the buffer since it was last written or read
    isModified: bool,

    /// List of active modes
    /// Must be sorted
    modeList: *Mode,

    pub fn init(allocator: std.mem.Allocator, name: []const u8) !void {
        _ = allocator;
        _ = name;

        return . {

        };
    }

    pub fn deinit(self: *Buffer) !void {

    }

};

const Mark = struct {
    /// The next mark in the linked list
    /// null indicates end of list
    nextMark: ?*Mark,
    /// Convenience for users to refer to specific marks
    /// possibly, return a pointer to the mark struct rather than a name
    name: MarkName, // TODO: why not string?
    /// The location of the mark in the file
    point: Location,
    /// Is it a fixed mark?
    isFixed: bool,

};

const TestError = error { a };

const Mode = struct {
    /// The next mode in the linked list
    /// null indicates end of list
    nextMode: ?*Mode,
    /// The name of the mode
    modeName: []const u8,

    /// Execute whenever the buffers command set neets to be (re)created
    /// makes required modifications to global command tables anre returns status
    addProc: *const fn() TestError.a!void,  // TODO: fix inferred error set

};

pub fn main() !void {

}
