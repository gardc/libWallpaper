const std = @import("std");
const libWallpaper = @import("libWallpaper");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    // Get the program name (arg 0) for the usage message.
    const prog_name = args.next() orelse "set-wallpaper";

    // Get the image path (arg 1).
    const image_path = args.next() orelse {
        // Print usage error to stderr
        std.debug.print("Usage: {s} <path_to_image_file>\n", .{prog_name});
        // Exit with a non-zero status code to indicate failure
        std.process.exit(1);
    };

    std.debug.print("Setting wallpaper to: {s}\n", .{image_path});

    // The allocator is still passed to libWallpaper, as in the original code.
    libWallpaper.setWallpaperImage(allocator, image_path, true) catch |err| {
        std.debug.print("Failed to set wallpaper: {}\n", .{err});
        return err;
    };

    std.debug.print("Wallpaper set successfully!\n", .{});
}

// test "simple test" {
//     const gpa = std.testing.allocator;
//     var list: std.ArrayList(i32) = .empty;
//     defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
//     try list.append(gpa, 42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }

// test "fuzz example" {
//     const Context = struct {
//         fn testOne(context: @This(), input: []const u8) anyerror!void {
//             _ = context;
//             // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
//             try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
//         }
//     };
//     try std.testing.fuzz(Context{}, Context.testOne, .{});
// }
