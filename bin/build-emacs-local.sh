#!/bin/bash
set -e

# ==============================================================================
# Emacs Local Build Script (Non-root) with Tree-sitter Support
# ==============================================================================
# This script helps you compile Emacs with tree-sitter support locally in your
# home directory. This is useful for servers where you don't have root access.
#
# PREREQUISITES (Offline Mode):
# 1. Download 'emacs-30.x.tar.xz' and place it in the same directory as this script.
# 2. Download 'tree-sitter-x.x.x.tar.gz' (source code) and place it here.
#
# USAGE:
#   ./build-emacs-local.sh
# ==============================================================================

# 1. Configuration
# ----------------
INSTALL_PREFIX="$HOME/.local"
BUILD_DIR="$HOME/emacs-build-temp"
JOBS=$(nproc)

# Versions (Update these to match your downloaded files)
# If files are not found, the script will try to find any matching tarball.
EMACS_TARBALL=$(find . -maxdepth 1 -name "emacs-*.tar.xz" | head -n 1)
TREESITTER_TARBALL=$(find . -maxdepth 1 -name "tree-sitter-*.tar.gz" | head -n 1)

# 2. Environment Setup
# --------------------
mkdir -p "$INSTALL_PREFIX/bin"
mkdir -p "$INSTALL_PREFIX/lib"
mkdir -p "$INSTALL_PREFIX/include"
mkdir -p "$BUILD_DIR"

export PATH="$INSTALL_PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$INSTALL_PREFIX/lib:$LD_LIBRARY_PATH"
export LIBRARY_PATH="$INSTALL_PREFIX/lib:$LIBRARY_PATH"
export C_INCLUDE_PATH="$INSTALL_PREFIX/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="$INSTALL_PREFIX/include:$CPLUS_INCLUDE_PATH"
export PKG_CONFIG_PATH="$INSTALL_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"

echo "=== Environment Configured ==="
echo "Prefix: $INSTALL_PREFIX"
echo "Build Dir: $BUILD_DIR"
echo "Jobs: $JOBS"
echo ""

# 3. Build Tree-sitter (if needed)
# --------------------------------
if pkg-config --exists tree-sitter; then
    echo "[Skip] Tree-sitter already installed (found via pkg-config)."
else
    echo "[Build] Building Tree-sitter..."
    if [ -z "$TREESITTER_TARBALL" ]; then
        echo "Error: Tree-sitter tarball not found!"
        echo "Please download the source code (e.g., tree-sitter-0.20.8.tar.gz) and place it in this directory."
        exit 1
    fi
    
    cd "$BUILD_DIR"
    tar -xf "$PWD/../$TREESITTER_TARBALL"
    cd tree-sitter-*
    
    # Generic build for tree-sitter
    make -j"$JOBS"
    make install PREFIX="$INSTALL_PREFIX"
    
    echo "[Success] Tree-sitter installed to $INSTALL_PREFIX"
    cd ..
fi

# 4. Build Emacs
# --------------
echo "[Build] Building Emacs..."
if [ -z "$EMACS_TARBALL" ]; then
    echo "Error: Emacs tarball not found!"
    echo "Please download Emacs source (e.g., emacs-29.4.tar.xz) and place it in this directory."
    exit 1
fi

cd "$BUILD_DIR"
# Remove old build if exists
rm -rf emacs-*/
tar -xf "$PWD/../$EMACS_TARBALL"
cd emacs-*

echo "Configuring Emacs..."
./configure 
    --prefix="$INSTALL_PREFIX" 
    --with-tree-sitter 
    --with-modules 
    --with-json 
    --without-dbus 
    --without-pop 
    --with-mailutils 
    --without-gconf 
    --without-gsettings 
    --with-native-compilation=aot 
    CFLAGS="-O3 -mtune=native -march=native"

echo "Compiling Emacs (This may take a while)..."
make -j"$JOBS"

echo "Installing Emacs..."
make install

echo ""
echo "=========================================================="
echo "Build Complete!"
echo "=========================================================="
echo "Make sure to add the following to your shell config (.bashrc/.zshrc):"
echo ""
echo "export PATH="$INSTALL_PREFIX/bin:\$PATH""
echo "export LD_LIBRARY_PATH="$INSTALL_PREFIX/lib:\$LD_LIBRARY_PATH""
echo ""
echo "Then restart your shell and run 'emacs --version' to verify."
