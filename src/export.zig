const libWallpaper = @import("libWallpaper");
const std = @import("std");

pub export fn externSetWallpaperImage(image_path: [*:0]const u8, stretch: bool) i32 {
    const allocator = std.heap.page_allocator;

    const image_path_str = std.mem.span(image_path);

    libWallpaper.setWallpaperImage(allocator, image_path_str, stretch) catch |err| {
        return @intFromError(err);
    };
    return 0;
}
