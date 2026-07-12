@echo off
echo ============================================
echo Uninstalling ProjectContent...
echo ============================================

reg delete "HKCR\Directory\shell\GenerateProjectContent" /f

echo.
echo ProjectContent has been removed from the context menu.
echo.

pause