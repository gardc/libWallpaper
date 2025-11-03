#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

// Set wallpaper on all displays
// imagePath: UTF-8 encoded file path
// stretch: 1 for stretch/fill, 0 for center/tile
// Returns 0 on success, non-zero on error
int SetWallpaperImage(const char* imagePath, int stretch) {
    if (!imagePath) {
        return 1; // EINVAL equivalent
    }
    
    @autoreleasepool {
        // Convert C string to NSString
        NSString* pathString = [NSString stringWithUTF8String:imagePath];
        if (!pathString) {
            return 1; // Invalid UTF-8
        }
        
        // Convert to file URL
        NSURL* imageURL = [NSURL fileURLWithPath:pathString];
        if (!imageURL) {
            return 1;
        }
        
        // Check if file exists
        if (![[NSFileManager defaultManager] fileExistsAtPath:pathString]) {
            return 2; // File not found
        }
        
        // Get NSScreen list (all displays)
        NSArray<NSScreen*>* screens = [NSScreen screens];
        if (!screens || [screens count] == 0) {
            return 3; // No screens found
        }
        
        // Get NSWorkspace shared instance
        NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
        if (!workspace) {
            return 4; // Failed to get workspace
        }
        
        // Determine scaling option based on stretch parameter
        NSImageScaling scaling;
        if (stretch) {
            scaling = NSImageScaleAxesIndependently; // Stretch to fill screen
        } else {
            scaling = NSImageScaleNone; // Center without scaling
        }
        
        // Create options dictionary
        NSDictionary* options = @{
            NSWorkspaceDesktopImageScalingKey: @(scaling),
            NSWorkspaceDesktopImageFillColorKey: [NSColor blackColor]
        };
        
        // Set wallpaper for each screen
        NSError* error = nil;
        for (NSScreen* screen in screens) {
            BOOL success = [workspace setDesktopImageURL:imageURL
                                               forScreen:screen
                                                  options:options
                                                    error:&error];
            if (!success) {
                // Return error code
                return 5; // Failed to set wallpaper
            }
        }
        
        return 0; // Success
    }
}

