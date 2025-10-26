const std = @import("std");
const clap = @import("clap");

pub const Args = struct {
    path: []const u8,
    command: []const u8,
    allocator: *std.mem.Allocator,
    // pub fn deinit(self: Args) void {
    // }
};

pub fn parseArgs(allocator: *std.mem.Allocator) !Args {
    const params = comptime clap.parseParamsComptime(
        \\-h, --help             Display this help and exit.
        \\-p, --path <FILE>      Input Path for executable file. (required)
        \\-c, --command <CMD>    Command to execute on given Path. (required)
    );

    const parsers = comptime .{
        .FILE = clap.parsers.string,
        .CMD = clap.parsers.string,
    };

    var diag = clap.Diagnostic{};
    const res = clap.parse(clap.Help, &params, parsers, .{
        .diagnostic = &diag,
        .allocator = allocator.*,
    }) catch {
        std.debug.print("Invalid arguments\n", .{});
        std.process.exit(1);
    };

    if (res.args.help != 0) {
        printHelp();
        std.process.exit(0);
    }

    const path = res.args.path orelse {
        std.debug.print("Path is required.\n", .{});
        std.process.exit(1);
    };

    const cmd = res.args.command orelse {
        std.debug.print("Command is required.\n", .{});
        std.process.exit(1);
    };

    return Args{ .path = path, .command = cmd, .allocator = allocator };
}

fn printHelp() void {
    std.debug.print(
        \\Help for Tracer
        \\
        \\-h, --help             Display this help and exit.
        \\-p, --path <FILE>      Input Path for executable file. (required)
        \\-c, --command <CMD>    Command to execute on given Path. (required)
        \\
        \\Example:
        \\  Tracer -p ./test.js -c node
        \\
    ,
        .{},
    );
}
