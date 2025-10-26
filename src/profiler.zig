const std = @import("std");
const windows = std.os.windows;
const cli = @import("./cli.zig");
const PrintTables = @import("./printer/printTables.zig");
const Types = @import("types.zig");
const ctime = @cImport({
    @cInclude("time.h");
});

fn toGB(b: usize) f32 {
    return @as(f32, @floatFromInt(b)) / (1024 * 1024 * 1024);
}
fn toMB(b: usize) f32 {
    return @as(f32, @floatFromInt(b)) / (1024 * 1024);
}

pub fn printIntroStatus(child: *std.process.Child, args: *cli.Args) !void {
    child.request_resource_usage_statistics = true;
    const start_time = std.time.milliTimestamp();

    std.debug.print("\n--- EXECUTING ---\n TIMESTAMP: {d}\n COMMAND: {s} {s}\n\n", .{ std.time.timestamp(), args.command, args.path });
    child.spawn() catch {
        std.debug.print("--- EXECUTING FAILED [ABRUPT ENDING] ---\n\n", .{});
        std.process.exit(1);
        _ = child.kill() catch {
            std.debug.print("\n-- KILLING PROCESS FAILED --\n", .{});
            std.process.exit(1);
        };
    };

    std.debug.print("--- STDOUT ---\n", .{});
    const wait = child.wait() catch {
        std.debug.print("\n-- WAITING FOR PROCESS FAILED --\n", .{});
        std.process.exit(1);
    };
    const elapsed: i64 = std.time.milliTimestamp() - start_time;
    if (wait.Exited != 0) { // Error
        std.debug.print("\n--- EXECUTING FAILED [ABRUPT ENDING] ---\n\n", .{});
        std.process.exit(1);
        _ = child.kill() catch {
            std.debug.print("\n-- KILLING PROCESS FAILED --\n", .{});
            std.process.exit(1);
        };
        return;
    }
    std.debug.print("\n\n\n", .{});

    var keys = [_][]const u8{ "EXECUTEABLE TOOK (ms)", "SIGNAL RECEIVED" };
    var values = [_]Types.PrintTablesType(i64){ Types.PrintTablesType(i64){ .value = elapsed, .suffix = "ms", .printType = Types.PrintStyle.Int }, Types.PrintTablesType(i64){
        .value = wait.Exited,
        .printType = Types.PrintStyle.Int,
    } };

    PrintTables.printTables(i64, "EXECUTER", &keys, &values, 30) catch {
        std.debug.print("\n-- PRINTING TABLES FAILED --\n", .{});
        std.process.exit(1);
    };
}

pub fn printVmStats(vm: windows.VM_COUNTERS) !void {
    const v_gb = toGB(vm.PeakVirtualSize);
    const w_mb = toMB(vm.PeakWorkingSetSize);

    var keys = [_][]const u8{ "PEAK VSIZE", "PEAK WSS", "PAGE FAULT COUNT" };
    var values = [_]Types.PrintTablesType(f32){ Types.PrintTablesType(f32){ .value = v_gb, .suffix = " GB", .printType = Types.PrintStyle.Float2 }, Types.PrintTablesType(f32){ .value = w_mb, .suffix = " MB", .printType = Types.PrintStyle.Float2 }, Types.PrintTablesType(f32){ .value = @as(f32, @floatFromInt(vm.PageFaultCount)), .suffix = " PAGES", .printType = Types.PrintStyle.Int } };

    PrintTables.printTables(f32, "PROFILER", &keys, &values, 20) catch {
        std.debug.print("\n-- PRINTING TABLES FAILED --\n", .{});
        std.process.exit(1);
    };
}
