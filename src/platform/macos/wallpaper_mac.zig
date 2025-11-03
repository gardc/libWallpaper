const std = @import("std");
const WallpaperError = @import("../../root.zig").WallpaperError;

// External C function from wallpaper_mac.m
extern "c" fn SetWallpaperImage(imagePath: [*c]const u8, stretch: c_int) c_int;

/// Set a wallpaper image on all monitors.
///
/// Returns an error if the operation failed.
///
/// `image_path` should be a valid macOS path (e.g., "/path/to/image.jpg")
/// `stretch` controls whether the image should be stretched to fill the screen (true) or centered (false)
/// `allocator` is used for temporary string conversion buffers.
pub fn setWallpaperImage(allocator: std.mem.Allocator, image_path: []const u8, stretch: bool) WallpaperError!void {
    // Convert to null-terminated C string
    const c_path = try allocator.dupeZ(u8, image_path);
    defer allocator.free(c_path);

    const stretch_int: c_int = if (stretch) 1 else 0;
    const result = SetWallpaperImage(c_path.ptr, stretch_int);
    if (result != 0) {
        std.debug.print("Failed to set wallpaper: {}\n", .{result});
        return WallpaperError.SetWallpaperFailed;
    }
}
