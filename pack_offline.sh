#!/bin/bash

# Configuration
DIST_DIR="emacs_dist"
EMACS_D="$HOME/.emacs.d"
BIN_DIR="$EMACS_D/bin"

echo ">>> Starting Offline Package Build..."

# 0. Strict Pre-flight Check
# Define critical files and binaries that MUST exist.
CRITICAL_FILES=(
    "$EMACS_D/init.el"
    "$EMACS_D/lisp/init-offline.el"
    "$EMACS_D/lisp/init-treesit.el"
)

CRITICAL_BINS=(
    "rg"
    "verible-verilog-ls"
)

echo ">>> Checking critical dependencies..."
MISSING_DEPS=0

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "!!! FATAL ERROR: Missing critical config file: $file"
        MISSING_DEPS=1
    fi
done

for bin in "${CRITICAL_BINS[@]}"; do
    if command -v "$bin" &> /dev/null; then
        # Found in global PATH
        :
    elif [ -f "$BIN_DIR/$bin" ] && [ -x "$BIN_DIR/$bin" ]; then
        # Found in local bin/
        echo ">>> Found $bin in local bin directory: $BIN_DIR/$bin"
        # Temporarily add to PATH for subsequent steps or just note it's safe
        export PATH="$BIN_DIR:$PATH"
    else
        echo "!!! FATAL ERROR: Missing critical binary: $bin (checked PATH and $BIN_DIR)"
        MISSING_DEPS=1
    fi
done

# Check for Tree-sitter library directory (usually in tree-sitter or .emacs.d/tree-sitter)
# Emacs 29+ usually puts them in user-emacs-directory/tree-sitter
if [ ! -d "$EMACS_D/tree-sitter" ]; then
    echo "!!! FATAL ERROR: Tree-sitter grammar directory not found at $EMACS_D/tree-sitter"
    echo "    Please run (my/treesit-install-all-grammars) in Emacs first."
    MISSING_DEPS=1
fi

if [ "$MISSING_DEPS" -eq 1 ]; then
    echo ">>> Aborting build due to missing dependencies."
    exit 1
fi

echo ">>> All critical dependencies found. Proceeding..."

# 1. Prepare Dist Directory
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"
mkdir -p "$DIST_DIR/bin"
mkdir -p "$DIST_DIR/fonts"

# 2. Copy .emacs.d (Clean)
echo ">>> Copying configuration..."
rsync -av --progress "$EMACS_D/" "$DIST_DIR/.emacs.d/" \
    --exclude '.git' \
    --exclude '.gitignore' \
    --exclude 'tmp' \
    --exclude 'backups' \
    --exclude 'auto-save-list' \
    --exclude 'eln-cache' \
    --exclude 'offline' \
    --exclude 'emacs_dist' \
    --exclude 'emacs_offline_deploy.tar.gz' # Prevent recursive copying

# 3. Collect Tree-sitter Grammars
# Standard location for tree-sitter libs in Emacs 29+
TS_DIR="$HOME/.emacs.d/tree-sitter"
if [ -d "$TS_DIR" ]; then
    echo ">>> Found compiled Tree-sitter grammars, including them..."
    cp -r "$TS_DIR" "$DIST_DIR/.emacs.d/"
else
    echo "!!! WARNING: No compiled tree-sitter grammars found at $TS_DIR"
    echo "!!! Please run M-x my/treesit-install-all-grammars inside Emacs before packing if you want them."
fi

# 4. Attempt to find and bundle binaries (ripgrep, fd, verible)
# This assumes they are in the PATH of the current machine.
find_and_copy() {
    CMD=$1
    LOC=$(which "$CMD")
    if [ ! -z "$LOC" ]; then
        echo ">>> Bundling binary: $CMD (from $LOC)"
        cp "$LOC" "$DIST_DIR/bin/"
    else
        echo "!!! WARNING: Binary '$CMD' not found in PATH. You may need to add it manually to dist/bin/"
    fi
}

find_and_copy "rg"
find_and_copy "fd"
find_and_copy "verible-verilog-ls"

# 4b. Bundle Fonts
echo ">>> Bundling Fonts..."
# JetBrains Mono Nerd Font (Regular & Bold)
JB_REG="$HOME/.local/share/fonts/JetBrainsMonoNerdFontMono-Regular.ttf"
JB_BOLD="$HOME/.local/share/fonts/JetBrainsMonoNerdFontMono-Bold.ttf"
CJK_REG="/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"

if [ -f "$JB_REG" ]; then cp "$JB_REG" "$DIST_DIR/fonts/"; else echo "!!! Warning: $JB_REG not found"; fi
if [ -f "$JB_BOLD" ]; then cp "$JB_BOLD" "$DIST_DIR/fonts/"; else echo "!!! Warning: $JB_BOLD not found"; fi
if [ -f "$CJK_REG" ]; then cp "$CJK_REG" "$DIST_DIR/fonts/"; else echo "!!! Warning: $CJK_REG not found"; fi

# 5. Create the Install Script for the Remote Machine
cat > "$DIST_DIR/install.sh" << 'EOF'
#!/bin/bash
set -e

INSTALL_DIR="$HOME/.emacs.d"
BACKUP_DIR="$HOME/.emacs.d.bak.$(date +%s)"
BIN_DIR="$HOME/bin"
FONT_DIR="$HOME/.local/share/fonts"

echo ">>> Installing Offline Emacs Environment..."

# 1. Backup existing
if [ -d "$INSTALL_DIR" ]; then
    echo ">>> Backing up existing .emacs.d to $BACKUP_DIR"
    mv "$INSTALL_DIR" "$BACKUP_DIR"
fi

# 2. Deploy
echo ">>> Deploying configuration..."
cp -r .emacs.d "$HOME/"

# 3. Mark as Offline
touch "$HOME/.emacs.d/offline"
echo ">>> Enabled Offline Mode (created ~/.emacs.d/offline)"

# 4. Install Binaries
mkdir -p "$BIN_DIR"
echo ">>> Installing binaries to $BIN_DIR..."
cp bin/* "$BIN_DIR/" 2>/dev/null || echo "No binaries to install."
chmod +x "$BIN_DIR/"*

# 5. Install Fonts
echo ">>> Installing Fonts..."
mkdir -p "$FONT_DIR"
cp fonts/* "$FONT_DIR/" 2>/dev/null || echo "No fonts to install."
if command -v fc-cache &> /dev/null; then
    echo ">>> Updating font cache..."
    fc-cache -f -v > /dev/null
else
    echo "!!! Warning: fc-cache not found. You may need to restart or install fontconfig."
fi

# 6. Environment Setup Hint
echo ""
echo "============================================================"
echo "INSTALLATION COMPLETE"
echo "============================================================"
echo "Please add the following to your ~/.bashrc (or ~/.zshrc):"
echo ""
echo "  export PATH="\$HOME/bin:\$PATH""
echo ""
echo "Then restart your shell."
echo "============================================================"
EOF

chmod +x "$DIST_DIR/install.sh"

# 6. Compress and Split

echo ">>> Compressing package and splitting into 128M volumes..."

rm -f emacs_offline_deploy.tar.gz.*

tar -cz -C "$DIST_DIR" . | split -b 128M -d - "emacs_offline_deploy.tar.gz."

rm -rf "$DIST_DIR"



echo ">>> DONE! Multi-volume package ready:"

ls -lh emacs_offline_deploy.tar.gz.*

echo ""

echo ">>> extraction hint:"

echo ">>> cat emacs_offline_deploy.tar.gz.* | tar -xzv"
