#!/bin/sh

echo "========================================================"
echo "     Emacs Package Cleaner (Fix Corrupted Installs)"
echo "========================================================"
echo ""
echo "This script will delete all installed packages and caches."
echo "Emacs will re-download them cleanly upon next startup."
echo ""
echo "[WARNING] Ensure Emacs is CLOSED before continuing!"
echo ""
read -p "Press [Enter] key to continue..."

echo ""
echo "[1/3] Deleting ELPA directory (Packages)..."
if [ -d "elpa" ]; then
    rm -rf "elpa"
    echo "Done."
else
    echo "\"elpa\" folder not found. Skipping."
fi

echo ""
echo "[2/3] Deleting ELN-CACHE (Native Comp cache)..."
if [ -d "eln-cache" ]; then
    rm -rf "eln-cache"
    echo "Done."
else
    echo "\"eln-cache\" folder not found. Skipping."
fi

echo ""
echo "[3/3] Cleaning auto-save lists..."
if [ -d "auto-save-list" ]; then
    rm -rf "auto-save-list"
    echo "Done."
fi

echo ""
echo "========================================================"
echo "     Cleanup Complete!"
echo "========================================================"
echo "Now restart Emacs and wait for it to reinstall everything."
echo ""
