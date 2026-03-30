#!/bin/bash

# setup.sh - Initialize Gemini Emacs Environment for fast deployment

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
    sudo apt-get install -y git cmake g++ ripgrep curl unzip tar fonts-noto-cjk
elif command -v pacman &> /dev/null; then
    # Arch Linux
    sudo pacman -S --noconfirm git cmake gcc ripgrep curl unzip tar adobe-source-han-sans-cn-fonts
else
    echo "⚠️  Unsupported package manager. Please manually install: git, cmake, g++, ripgrep"
fi

# 2. Font Setup (Automatic for Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🅰️  Installing Nerd Fonts (NFM.ttf)..."
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    if [ -f "$EMACS_DIR/fonts/NFM.ttf" ]; then
        cp "$EMACS_DIR/fonts/NFM.ttf" "$FONT_DIR/"
        if command -v fc-cache &> /dev/null; then
            fc-cache -f "$FONT_DIR"
            echo "✅ Font installed and cache updated."
        fi
    else
        echo "⚠️  NFM.ttf not found in fonts/ directory."
    fi
fi

# 3. Install Verible (SystemVerilog LSP)
echo "🛠  Setting up Verible (SystemVerilog LSP)..."
if [ ! -f "$BIN_DIR/verible-verilog-ls" ]; then
    echo "   Downloading Verible..."
    VERIBLE_URL="https://github.com/chipsalliance/verible/releases/download/v0.0-4051-g9fdb4057/verible-v0.0-4051-g9fdb4057-linux-static-x86_64.tar.gz"
    
    curl -L "$VERIBLE_URL" -o /tmp/verible.tar.gz
    tar -xzf /tmp/verible.tar.gz -C /tmp
    
    cp /tmp/verible-*-linux-static-x86_64/bin/* "$BIN_DIR/"
    chmod +x "$BIN_DIR/"*
    
    rm -rf /tmp/verible*
    echo "✅ Verible installed to $BIN_DIR"
else
    echo "✅ Verible already installed."
fi

# 4. Create local.el Placeholder
if [ ! -f "$EMACS_DIR/local.el" ]; then
    echo ";; Local configuration for this machine" > "$EMACS_DIR/local.el"
    echo "✅ Created local.el (ignored by git)"
fi

# 5. Finalize
echo "🎉 Setup Complete!"
echo "   Next steps:"
echo "   1. Open Emacs, it will automatically download packages (if online)."
echo "   2. Use 'C-c x' to toggle proxy if download is slow."
echo "   3. Put machine-specific settings in 'local.el'."
