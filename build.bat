@echo off
REM ================================
REM BrainrotGame - Build Script
REM ================================
REM This script builds the Roblox place file from source code.

echo.
echo ========================================
echo   BRAINROT GAME - BUILD SCRIPT
echo ========================================
echo.

REM Check if Rojo is available
where rojo >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Rojo not found!
    echo Please install Rojo first by running: aftman install
    echo.
    pause
    exit /b 1
)

echo [1/3] Checking project configuration...
if not exist "default.project.json" (
    echo [ERROR] default.project.json not found!
    echo Make sure you're running this from the project root directory.
    echo.
    pause
    exit /b 1
)
echo [OK] Project configuration found.
echo.

echo [2/3] Building Roblox place file...
echo Running: rojo build -o BrainrotGame.rbxl
echo.

rojo build -o BrainrotGame.rbxl

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Build failed!
    echo Check the error messages above.
    echo.
    pause
    exit /b 1
)

echo.
echo [3/3] Verifying build output...

if not exist "BrainrotGame.rbxl" (
    echo [ERROR] BrainrotGame.rbxl was not created!
    echo.
    pause
    exit /b 1
)

REM Check if file size is reasonable (> 1KB)
for %%A in (BrainrotGame.rbxl) do set size=%%~zA
if %size% LSS 1024 (
    echo [WARNING] Build file seems too small (%size% bytes^)
    echo The build might be incomplete or corrupted.
    echo.
)

echo [OK] Build complete!
echo.
echo ========================================
echo   BUILD SUCCESSFUL!
echo ========================================
echo.
echo File created: BrainrotGame.rbxl
echo File location: %CD%\BrainrotGame.rbxl
echo.
echo NEXT STEPS:
echo  1. Open BrainrotGame.rbxl in Roblox Studio
echo  2. Build the 3D world (see WORKSPACE_SETUP.md^)
echo  3. Create the UI (see README.md^)
echo  4. Press F5 to test!
echo.
echo For complete handover instructions, see:
echo  - PROJECT_HANDOVER.md
echo  - HANDOVER_CHECKLIST.md
echo.
pause
