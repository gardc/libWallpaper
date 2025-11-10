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
pub fn setWallpaperImageZ(image_path: [:0]const u8, stretch: bool) WallpaperError!void {
    const stretch_int: c_int = if (stretch) 1 else 0;
    const result = SetWallpaperImage(image_path.ptr, stretch_int);
    if (result != 0) {
        // std.debug.print("Failed to set wallpaper: {}\n", .{result});
        return WallpaperError.SetWallpaperFailed;
    }
}
