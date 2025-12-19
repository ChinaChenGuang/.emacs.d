@echo off
echo ========================================================
echo      Emacs Package Cleaner (Fix Corrupted Installs)
echo ========================================================
echo.
echo This script will delete all installed packages and caches.
echo Emacs will re-download them cleanly upon next startup.
echo.
echo [WARNING] Ensure Emacs is CLOSED before continuing!
echo.
pause

echo.
echo [1/3] Deleting ELPA directory (Packages)...
if exist "elpa" (
    rmdir /s /q "elpa"
    echo Done.
) else (
    echo "elpa" folder not found. Skipping.
)

echo.
echo [2/3] Deleting ELN-CACHE (Native Comp cache)...
if exist "eln-cache" (
    rmdir /s /q "eln-cache"
    echo Done.
) else (
    echo "eln-cache" folder not found. Skipping.
)

echo.
echo [3/3] Cleaning auto-save lists...
if exist "auto-save-list" (
    rmdir /s /q "auto-save-list"
    echo Done.
)

echo.
echo ========================================================
echo      Cleanup Complete! 
echo ========================================================
echo Now restart Emacs and wait for it to reinstall everything.
echo.
pause