//! libWallpaper - A cross-platform library for setting wallpapers
const std = @import("std");
const builtin = @import("builtin");

const windows_native = @import("platform/windows/lib_win.zig");
const macos_native = @import("platform/macos/wallpaper_mac.zig");

// Public error types
pub const WallpaperError = error{
    SetWallpaperFailed,
    UnsupportedPlatform,
    OutOfMemory,
    InvalidUtf8,
};

/// Set a wallpaper image on all monitors.
///
/// Returns an error if the operation failed.
///
/// `allocator` is used for temporary string conversion buffers.
/// `image_path` should be a valid path to an image file.
/// `stretch` controls whether the image should be stretched to fill the screen (true) or centered (false).
///
/// **Supported platforms:** Windows, macOS (other platforms return UnsupportedPlatform)
pub fn setWallpaperImage(allocator: std.mem.Allocator, image_path: []const u8, stretch: bool) WallpaperError!void {
    if (builtin.os.tag == .windows) {
        return windows_native.setWallpaperImage(allocator, image_path, stretch);
    } else if (builtin.os.tag == .macos) {
        return macos_native.setWallpaperImage(allocator, image_path, stretch);
    }
    return error.UnsupportedPlatform;
}
