#!/bin/bash

# Configuration
DIST_DIR="emacs_dist"
EMACS_D="$HOME/.emacs.d"
BIN_DIR="$EMACS_D/bin"

echo ">>> Starting Offline Package Build (Configuration Only)..."

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
    --exclude 'emacs_config_deploy.tar.gz' \
    --exclude 'emacs_offline_deploy.tar.gz' \
    --exclude 'deps' # Exclude large source files

# Ensure elpa directory is present
if [ ! -d "$EMACS_D/elpa" ]; then
    echo "!!! Warning: 'elpa' directory not found. Configuration might be broken in offline mode."
fi

# 3. Collect Tree-sitter Grammars (Pre-compiled)
TS_DIR="$HOME/.emacs.d/tree-sitter"
if [ -d "$TS_DIR" ]; then
    echo ">>> Found compiled Tree-sitter grammars, including them..."
    cp -r "$TS_DIR" "$DIST_DIR/.emacs.d/"
fi

# 4. Bundle Helper Binaries (rg, fd, verible)
# Only bundle if found, no building.
find_and_copy() {
    CMD=$1
    LOC=$(which "$CMD")
    if [ ! -z "$LOC" ]; then
        echo ">>> Bundling binary: $CMD"
        cp "$LOC" "$DIST_DIR/bin/"
    elif [ -f "$BIN_DIR/$CMD" ]; then
        echo ">>> Bundling binary: $CMD (from local bin)"
        cp "$BIN_DIR/$CMD" "$DIST_DIR/bin/"
    else
        echo "!!! Info: Binary '$CMD' not found. Skipping."
    fi
}

find_and_copy "rg"
find_and_copy "fd"
find_and_copy "verible-verilog-ls"

# 5. Bundle Fonts
echo ">>> Bundling Fonts..."
JB_REG="$HOME/.local/share/fonts/JetBrainsMonoNerdFontMono-Regular.ttf"
JB_BOLD="$HOME/.local/share/fonts/JetBrainsMonoNerdFontMono-Bold.ttf"
if [ -f "$JB_REG" ]; then cp "$JB_REG" "$DIST_DIR/fonts/"; fi
if [ -f "$JB_BOLD" ]; then cp "$JB_BOLD" "$DIST_DIR/fonts/"; fi

# 6. Create Install Script (No Compilation)
cat > "$DIST_DIR/install.sh" << 'EOF'
#!/bin/bash
set -e

INSTALL_DIR="$HOME/.emacs.d"
BACKUP_DIR="$HOME/.emacs.d.bak.$(date +%s)"
BIN_DIR="$HOME/bin"
FONT_DIR="$HOME/.local/share/fonts"

echo ">>> Starting Gemini Configuration Deployment..."

# 1. Backup
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
cp bin/* "$BIN_DIR/" 2>/dev/null || true
chmod +x "$BIN_DIR/"*

# 5. Install Fonts
echo ">>> Installing Fonts..."
mkdir -p "$FONT_DIR"
cp fonts/* "$FONT_DIR/" 2>/dev/null || true
if command -v fc-cache &> /dev/null; then
    fc-cache -f -v > /dev/null
fi

echo ""
echo "============================================================"
echo "DEPLOYMENT COMPLETE"
echo "============================================================"
echo "Ensure $HOME/bin is in your PATH."
echo "Restart Emacs."
EOF

chmod +x "$DIST_DIR/install.sh"

# 7. Compress
echo ">>> Compressing package..."
rm -f emacs_config_deploy.tar.gz
tar -czf emacs_config_deploy.tar.gz -C "$DIST_DIR" .
rm -rf "$DIST_DIR"

echo ">>> DONE! Package ready: emacs_config_deploy.tar.gz"