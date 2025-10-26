const std = @import("std");
const cli = @import("./cli.zig");
const Profiler = @import("./profiler.zig");
const PrintTables = @import("./printer/printTables.zig");
const Types = @import("types.zig");

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    var args = cli.parseArgs(&allocator) catch {
        std.debug.print("\n-- PARSING ARGUMENTS FAILED --\n", .{});
        std.process.exit(1);
    };
    const argv = [_][]const u8{ args.command, args.path };
    var child = std.process.Child.init(&argv, allocator);
    Profiler.printIntroStatus(&child, &args) catch {
        std.debug.print("\n-- PRINTING INTRO FAILED --\n", .{});
        std.process.exit(1);
    };

    if (child.resource_usage_statistics.rusage) |usage| {
        Profiler.printVmStats(usage) catch {
            std.debug.print("\n-- PRINTING VM STATS FAILED --\n", .{});
            std.process.exit(1);
        };
    }

    const kill = child.kill() catch {
        std.debug.print("\n-- KILLING PROCESS FAILED --\n", .{});
        std.process.exit(1);
    };
    var keys = [_][]const u8{"KILL SIGNAL"};

    var values = [_]Types.PrintTablesType(u8){Types.PrintTablesType(u8){ .value = kill.Exited, .printType = Types.PrintStyle.Int }};

    PrintTables.printTables(u8, "PROCESS KILLED", &keys, &values, 30) catch {
        std.debug.print("\n-- PRINTING TABLES FAILED --\n", .{});
        std.process.exit(1);
    };
}
