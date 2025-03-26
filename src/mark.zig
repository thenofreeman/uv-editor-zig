const std = @import("std");

const Location = @import("location.zig").Location;

pub const Mark = struct {
    point: Location,
    isFixed: bool,

    pub fn init() Mark {
        return .{
            .point = Location.init(),
            .isFixed = false,
        };
    }

    pub fn deinit() void {

    }

    pub fn compare(self: Mark, other: Mark) i32 {
        return self.point.compare(other.point);
    }
};
