const std = @import("std");

// Error types (matching root.zig)
const WallpaperError = error{
    WallpaperSetFailed,
    UnsupportedPlatform,
    OutOfMemory,
    InvalidUtf8,
};

// External C functions from lib_win.cpp
pub extern "c" fn SetWallpaperImage(imagePath: [*c]const u16, stretch: c_int) c_int;

/// Set a wallpaper image on all monitors.
///
/// Returns an error if the operation failed.
///
/// `image_path` should be a valid Windows path (e.g., "C:\\path\\to\\image.jpg")
/// `stretch` controls whether the image should be stretched to fill the screen (true) or centered (false)
/// `allocator` is used for temporary string conversion buffers.
pub fn setWallpaperImage(allocator: std.mem.Allocator, image_path: []const u8, stretch: bool) WallpaperError!void {
    // Convert to UTF-16 LE with null terminator (utf8ToUtf16LeAllocZ includes null terminator)
    const wide_path = try std.unicode.utf8ToUtf16LeAllocZ(allocator, image_path);
    defer allocator.free(wide_path);

    const stretch_int: c_int = if (stretch) 1 else 0;
    const result = SetWallpaperImage(wide_path.ptr, stretch_int);
    if (result != 0) {
        // HRESULT error code
        return WallpaperError.WallpaperSetFailed;
    }
}
