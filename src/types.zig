pub const PrintStyle = enum {
    Default,
    Float2,
    Float3,
    String,
    Int,
    Debug,
};

pub fn PrintTablesType(comptime T: type) type {
    return struct {
        printType: PrintStyle = PrintStyle.Default,
        value: T,
        prefix: []const u8 = "",
        suffix: []const u8 = "",
    };
}
