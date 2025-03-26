const std = @import("std");

pub const Location = struct {
    pos: usize,

    pub fn init() Location {
        return .{
            .pos = 0,
        };
    }

    pub fn compare(self: Location, other: Location) i32 {
        if (self.pos == other.pos) {
            return 0;
        } else if (self.pos > other.pos) {
            return 1;
        } else {
            return -1;
        }
    }
};
