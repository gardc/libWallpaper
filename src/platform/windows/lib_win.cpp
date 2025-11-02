#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0601
#endif

#include <windows.h>
#include <shobjidl.h>
#include <shlobj.h>
#include <string>
// Set a single wallpaper image on all monitors
// stretch: true for DWPOS_STRETCH, false for DWPOS_CENTER
extern "C" __declspec(dllexport) int SetWallpaperImage(const wchar_t *imagePath, int stretch)
{
    if (!imagePath)
        return E_INVALIDARG;

    HRESULT hr = CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    if (FAILED(hr))
        return hr;

    HRESULT result = E_FAIL;

    // Create a scope to ensure proper cleanup
    {
        // Create desktop wallpaper COM object
        IDesktopWallpaper *pDesktopWallpaper = nullptr;
        hr = CoCreateInstance(CLSID_DesktopWallpaper, nullptr, CLSCTX_ALL,
                              IID_PPV_ARGS(&pDesktopWallpaper));
        if (FAILED(hr))
        {
            result = hr;
            goto cleanup;
        }

        // Set position based on stretch parameter
        // DWPOS_STRETCH = 2, DWPOS_CENTER = 0
        DESKTOP_WALLPAPER_POSITION position = stretch ? DWPOS_STRETCH : DWPOS_CENTER;
        hr = pDesktopWallpaper->SetPosition(position);
        if (SUCCEEDED(hr))
        {
            // Set the wallpaper for all monitors by passing NULL as the monitor ID
            hr = pDesktopWallpaper->SetWallpaper(NULL, imagePath);
        }

        pDesktopWallpaper->Release();
        result = hr;
    }

cleanup:
    CoUninitialize();
    return SUCCEEDED(result) ? 0 : result;
}