@echo off
setlocal EnableDelayedExpansion

title ProjectContent Uninstaller

echo.
echo ============================================
echo        ProjectContent Uninstaller
echo ============================================
echo.

:: ------------------------------------------------------------
:: Request Administrator privileges
:: ------------------------------------------------------------

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ------------------------------------------------------------
:: Variables
:: ------------------------------------------------------------

set "INSTALL_DIR=%ProgramFiles%\ProjectContent"
set "OUTPUT_DIR=%USERPROFILE%\Desktop\ProjectContent"

if not exist "%INSTALL_DIR%" (
    echo ProjectContent is not installed.
    echo.
    pause
    exit /b
)

echo Installation found:
echo.
echo    %INSTALL_DIR%
echo.

choice /C YN /M "Uninstall ProjectContent"

if errorlevel 2 (
    echo.
    echo Uninstallation cancelled.
    pause
    exit /b
)

echo.
echo Removing Windows context menu...

reg delete "HKCR\Directory\shell\GenerateProjectContent" /f >nul

echo Context menu removed.
echo.

echo Removing installed files...

rmdir /S /Q "%INSTALL_DIR%"

echo Installed files removed.
echo.

if exist "%OUTPUT_DIR%" (

    echo Generated project content was found:

    echo.
    echo    %OUTPUT_DIR%
    echo.

    choice /C YN /M "Delete generated project content"

    if errorlevel 1 (
        rmdir /S /Q "%OUTPUT_DIR%"
        echo Generated files removed.
        echo.
    )

)

cls

echo ============================================
echo       Uninstallation Complete
echo ============================================
echo.

echo ProjectContent has been removed successfully.
echo.

pause