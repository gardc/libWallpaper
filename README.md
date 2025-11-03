# 🖼️ libWallpaper

A small, cross-platform library for setting the desktop wallpaper from native code.

Currently supported platforms
- Windows
- macOS

Status
- The codebase is designed to be cross-platform. At the moment, only the Windows and macOS backends are implemented and tested.

Quick build (requires Zig)
```sh
zig build
```

Where to look
- macOS implementation: `src/platform/macos`
- Windows implementation: `src/platform/windows`

Contributions welcome — please open issues or PRs for other platforms (Linux/BSD) or improvements.
