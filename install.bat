@echo off
setlocal EnableDelayedExpansion

title ProjectContent Installer

echo.
echo ============================================
echo         ProjectContent Installer
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

set "SOURCE_DIR=%~dp0"
if "%SOURCE_DIR:~-1%"=="\" set "SOURCE_DIR=%SOURCE_DIR:~0,-1%"

set "INSTALL_DIR=%ProgramFiles%\ProjectContent"
set "APP_DIR=%INSTALL_DIR%\app"

echo Source:
echo    %SOURCE_DIR%
echo.

echo Destination:
echo    %INSTALL_DIR%
echo.

:: ------------------------------------------------------------
:: Detect existing installation
:: ------------------------------------------------------------

if exist "%INSTALL_DIR%" (

    echo Existing installation detected.
    echo.

    choice /C YN /M "Update the existing installation"

    if errorlevel 2 (
        echo.
        echo Installation cancelled.
        pause
        exit /b
    )

) else (

    echo ProjectContent is not currently installed.
    echo.

    choice /C YN /M "Install ProjectContent"

    if errorlevel 2 (
        echo.
        echo Installation cancelled.
        pause
        exit /b
    )

)

echo.

:: ------------------------------------------------------------
:: Verify Python
:: ------------------------------------------------------------

echo Checking Python...

python --version >nul 2>&1

if errorlevel 1 (

    echo.
    echo ERROR:
    echo Python was not found.
    echo.
    echo Please install Python 3.10 or newer.
    echo.
    pause
    exit /b 1

)

echo Python detected.
echo.

:: ------------------------------------------------------------
:: Install Python packages
:: ------------------------------------------------------------

echo Installing Python dependencies...
echo.

python -m pip install -r "%SOURCE_DIR%\requirements.txt"

if errorlevel 1 (

    echo.
    echo Failed installing dependencies.
    pause
    exit /b 1

)

echo Dependencies installed.
echo.

:: ------------------------------------------------------------
:: Create installation folders
:: ------------------------------------------------------------

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%APP_DIR%" mkdir "%APP_DIR%"

echo Copying files...
echo.

copy /Y "%SOURCE_DIR%\projectcontent.py" "%APP_DIR%" >nul
copy /Y "%SOURCE_DIR%\generate_context.bat" "%APP_DIR%" >nul
copy /Y "%SOURCE_DIR%\requirements.txt" "%APP_DIR%" >nul
copy /Y "%SOURCE_DIR%\uninstall.bat" "%INSTALL_DIR%" >nul

echo Files copied.
echo.

:: ------------------------------------------------------------
:: Register Context Menu
:: ------------------------------------------------------------

echo Registering Windows context menu...
echo.

reg add "HKCR\Directory\shell\GenerateProjectContent" ^
/ve ^
/d "Generate Project Content" ^
/f >nul

reg add "HKCR\Directory\shell\GenerateProjectContent\command" ^
/ve ^
/d "\"%APP_DIR%\generate_context.bat\" \"%%1\"" ^
/f >nul

echo Context menu registered.
echo.

:: ------------------------------------------------------------
:: Complete
:: ------------------------------------------------------------

cls

echo ============================================
echo          Installation Successful
echo ============================================
echo.

echo Installation Directory
echo    %INSTALL_DIR%
echo.

echo Python Dependencies
echo    [OK] Installed
echo.

echo Context Menu
echo    [OK] Registered
echo.

echo Generated Files
echo    Desktop\ProjectContent
echo.

echo You may now delete the downloaded repository.
echo.

echo Right-click any folder and select:
echo.
echo    Generate Project Content
echo.

pause