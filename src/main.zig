const World = struct {
    bufferList: *Buffer,
    currentBuffer: *Buffer,

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

const Mode = struct {
    /// The next mode in the linked list
    /// null indicates end of list
    nextMode: ?*Mode,
    /// The name of the mode
    modeName: []const u8,

    pub fn addProc() status {

    }

};

pub fn main() !void {

}
