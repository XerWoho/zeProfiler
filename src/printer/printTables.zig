const std = @import("std");
const Types = @import("../types.zig");

fn printCell(content: []const u8, rowLength: usize) void {
    const padding = rowLength - content.len;
    const left = padding / 2;
    const right = padding - left;
    std.debug.print("|", .{});
    for (0..left) |_| std.debug.print(" ", .{});
    std.debug.print("{s}", .{content});
    for (0..right) |_| std.debug.print(" ", .{});
}

pub fn printTables(T: type, title: []const u8, keys: [][]const u8, values: []Types.PrintTablesType(T), rowLength: u8) !void {
    std.debug.print("{s}\n", .{title});
    for (keys) |key| {
        printCell(key, @as(usize, rowLength));
    }
    std.debug.print("|\n-", .{});
    for (0..keys.len) |i| {
        for (0..rowLength) |_| std.debug.print("-", .{});
        if (i != keys.len - 1) std.debug.print("+", .{});
        if (i == keys.len - 1) std.debug.print("-", .{});
    }
    std.debug.print("\n", .{});

    for (values) |value| {
        var buf: [64]u8 = undefined;
        const valueStr =
            switch (value.printType) {
                Types.PrintStyle.Default => try std.fmt.bufPrint(&buf, "{s}{any}{s}", .{ value.prefix, value.value, value.suffix }),
                Types.PrintStyle.Float2 => try std.fmt.bufPrint(&buf, "{s}{d:.2}{s}", .{ value.prefix, value.value, value.suffix }),
                Types.PrintStyle.Float3 => try std.fmt.bufPrint(&buf, "{s}{d:.3}{s}", .{ value.prefix, value.value, value.suffix }),
                Types.PrintStyle.Int => try std.fmt.bufPrint(&buf, "{s}{d}{s}", .{ value.prefix, value.value, value.suffix }),
                Types.PrintStyle.String => try std.fmt.bufPrint(&buf, "{s}{any}{s}", .{ value.prefix, value.value, value.suffix }),
                Types.PrintStyle.Debug => try std.fmt.bufPrint(&buf, "{s}{any}{s}", .{ value.prefix, value.value, value.suffix }),
            };

        printCell(valueStr, @as(usize, rowLength));
    }
    std.debug.print("|", .{});

    std.debug.print("\n\n", .{});
}
