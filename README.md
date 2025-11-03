# 🖼️ libWallpaper

A small, cross-platform library for setting the desktop wallpaper from native code.

Currently supported platforms
- Windows
- macOS

Status
- The codebase is designed to be cross-platform. At the moment, only the Windows and macOS backends are implemented and tested.

Usage

Below is a minimal Zig example showing how to call the library's API. The primary entry is:

- `pub fn setWallpaperImage(allocator: std.mem.Allocator, image_path: []const u8, stretch: bool) WallpaperError!void`

Example:

```zig
const std = @import("std");
const lib = @import("src/root.zig");

pub fn main() !void {
	const allocator = std.heap.page_allocator;
	// Path to the wallpaper image and whether to stretch it to fill the screen
	try lib.setWallpaperImage(allocator, "/path/to/wallpaper.jpg", true);
}
```

Stretch notes
- The `stretch` parameter is supported on the current backends. It must be provided together with the wallpaper path: pass `true` to stretch the image to fill the screen, or `false` to preserve aspect ratio / use the system default behaviour.

Quick build (requires Zig)
```sh
zig build
```

Where to look
- macOS implementation: `src/platform/macos`
- Windows implementation: `src/platform/windows`

Contributions welcome — please open issues or PRs for other platforms (Linux/BSD) or improvements.
