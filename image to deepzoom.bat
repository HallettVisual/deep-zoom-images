@echo off
setlocal enabledelayedexpansion

:: Set the input directory (where the script is located)
set "INPUT_DIR=%CD%"

:: Set the output directory (deepzoom subfolder)
set "OUTPUT_DIR=%INPUT_DIR%\deepzoom"

:: Ensure VIPS is installed and accessible
where vips >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: VIPS is not installed or not in PATH.
    echo Please install libvips from https://github.com/libvips/libvips/releases
    pause
    exit /b 1
)

:: Create output directory if it doesn't exist
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Process each image in the directory
for %%F in ("%INPUT_DIR%\*.jpg") do (
    set "FILENAME=%%~nF"
    set "OUTPUT_PATH=%OUTPUT_DIR%\!FILENAME!"

    echo Processing: %%F -> !OUTPUT_PATH!
    vips dzsave "%%F" "!OUTPUT_PATH!" --tile-size 256 --overlap 1 --suffix ".jpg" --layout dz

    if %errorlevel% neq 0 (
        echo ERROR: Failed to process %%F
    ) else (
        echo SUCCESS: Converted %%F to Deep Zoom format
    )
)

echo All images have been processed.
pause
exit /b 0
