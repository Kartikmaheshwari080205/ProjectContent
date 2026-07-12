@echo off
setlocal

echo ============================================
echo Installing ProjectContent...
echo ============================================

:: Get the directory where install.bat is located
set "SCRIPT_DIR=%~dp0"

:: Remove trailing backslash
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Create registry key
reg add "HKCR\Directory\shell\GenerateProjectContent" /ve /d "Generate Project Content" /f >nul

:: Set command
reg add "HKCR\Directory\shell\GenerateProjectContent\command" ^
/ve ^
/d "\"%SCRIPT_DIR%\generate_context.bat\" \"%%1\"" ^
/f >nul

echo.
echo Installation completed successfully.
echo.
echo You can now right-click any folder and choose:
echo.
echo     Generate Project Content
echo.

pause