#!/bin/bash

# setup.sh - Initialize Gemini Emacs Environment

set -e

EMACS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIN_DIR="$EMACS_DIR/bin"
mkdir -p "$BIN_DIR"

echo "🚀 Initializing Gemini Emacs Environment..."

# 1. Install System Dependencies
echo "📦 Checking system dependencies..."
if command -v apt-get &> /dev/null; then
    # Debian/Ubuntu
    sudo apt-get update
    sudo apt-get install -y git cmake g++ ripgrep curl unzip tar
elif command -v pacman &> /dev/null; then
    # Arch Linux
    sudo pacman -S --noconfirm git cmake gcc ripgrep curl unzip tar
else
    echo "⚠️  Unsupported package manager. Please manually install: git, cmake, g++, ripgrep"
fi

# 2. Install Verible (SystemVerilog LSP)
echo "🛠  Setting up Verible (SystemVerilog LSP)..."
if [ ! -f "$BIN_DIR/verible-verilog-ls" ]; then
    echo "   Downloading Verible..."
    # Get latest release URL (simplified for stability, hardcoded to a known working version if needed, or dynamic)
    # Using the version we tested: v0.0-4051-g9fdb4057
    VERIBLE_URL="https://github.com/chipsalliance/verible/releases/download/v0.0-4051-g9fdb4057/verible-v0.0-4051-g9fdb4057-linux-static-x86_64.tar.gz"
    
    curl -L "$VERIBLE_URL" -o /tmp/verible.tar.gz
    tar -xzf /tmp/verible.tar.gz -C /tmp
    
    # Move binaries
    cp /tmp/verible-*-linux-static-x86_64/bin/* "$BIN_DIR/"
    chmod +x "$BIN_DIR/"*
    
    # Clean up
    rm -rf /tmp/verible*
    echo "✅ Verible installed to $BIN_DIR"
else
    echo "✅ Verible already installed."
fi

# 3. Font Setup (Instructions)
echo "🅰️  Font Configuration:"
echo "   Please ensure you have the following fonts installed for the best experience:"
echo "   1. JetBrains Mono (Code)"
echo "   2. Microsoft YaHei or Noto Sans CJK SC (Chinese)"
echo "   3. Nerd Fonts (Symbols) - Run 'M-x nerd-icons-install-fonts' inside Emacs if icons are missing."

# 4. Finalize
echo "🎉 Setup Complete!"
echo "   Restart Emacs to verify the configuration."
