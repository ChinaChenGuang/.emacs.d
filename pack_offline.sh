#!/bin/bash

# =============================================================================
# Gemini Emacs Offline Packager
# 专注于现代补全堆栈、Tree-sitter 语法支持及终端/GUI 适配的离线部署
# =============================================================================

# Configuration
DIST_DIR="emacs_dist"
EMACS_D="$HOME/.emacs.d"
BIN_DIR="$EMACS_D/bin"

echo ">>> 🚀 开始构建 Gemini Emacs 离线部署包..."

# 1. 准备工作目录
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"
mkdir -p "$DIST_DIR/bin"
mkdir -p "$DIST_DIR/fonts"

# 2. 同步配置文件 (进行深度清理)
echo ">>> 📂 正在同步配置并清理缓存..."
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
    --exclude 'deps'

# 3. 准备兼容性组件 (针对 Emacs < 29)
echo ">>> 🛠️ 正在下载兼容性补丁 (use-package, compat)..."
mkdir -p "$DIST_DIR/.emacs.d/lisp/compat"
UP_BASE="https://raw.githubusercontent.com/jwiegley/use-package/master"
curl -sL "$UP_BASE/use-package.el" -o "$DIST_DIR/.emacs.d/lisp/compat/use-package.el"
curl -sL "$UP_BASE/use-package-core.el" -o "$DIST_DIR/.emacs.d/lisp/compat/use-package-core.el"
curl -sL "$UP_BASE/use-package-bind-key.el" -o "$DIST_DIR/.emacs.d/lisp/compat/use-package-bind-key.el"
curl -sL "$UP_BASE/bind-key.el" -o "$DIST_DIR/.emacs.d/lisp/compat/bind-key.el"

COMPAT_BASE="https://raw.githubusercontent.com/emacs-compat/compat/main"
for v in 27 28 29 30; do
    curl -sL "$COMPAT_BASE/compat-$v.el" -o "$DIST_DIR/.emacs.d/lisp/compat/compat-$v.el"
done
curl -sL "$COMPAT_BASE/compat.el" -o "$DIST_DIR/.emacs.d/lisp/compat/compat.el"
curl -sL "$COMPAT_BASE/compat-macs.el" -o "$DIST_DIR/.emacs.d/lisp/compat/compat-macs.el"

# 4. 包含 Tree-sitter 语法解析器 (离线高亮核心)
TS_DIR="$EMACS_D/tree-sitter"
if [ -d "$TS_DIR" ]; then
    echo ">>> 🧠 发现已编译的 Tree-sitter 语法包，正在打包..."
    cp -r "$TS_DIR" "$DIST_DIR/.emacs.d/"
else
    echo ">>> ⚠️ 警告: 未发现 tree-sitter 目录。离线环境下部分语言可能无法启用 -ts-mode。"
fi

# 5. 包含核心辅助工具 (rg, fd)
find_and_copy() {
    CMD=$1
    LOC=$(which "$CMD")
    if [ ! -z "$LOC" ]; then
        echo ">>> 🛠️ 打包工具: $CMD"
        cp "$LOC" "$DIST_DIR/bin/"
    fi
}
find_and_copy "rg"
find_and_copy "fd"
cp -r "$EMACS_D/bin/"* "$DIST_DIR/bin/" 2>/dev/null || true

# 6. 包含终端/GUI 适配字体
echo ">>> 🎨 打包适配字体 (Nerd Fonts)..."
if [ -f "fonts/NFM.ttf" ]; then
    cp "fonts/NFM.ttf" "$DIST_DIR/fonts/"
fi

# 7. 清理编译残留，确保跨版本兼容性
echo ">>> 🧹 清理 .elc 和 .eln 字节码..."
find "$DIST_DIR/.emacs.d/" -name "*.elc" -delete
find "$DIST_DIR/.emacs.d/" -name "*.eln" -delete
rm -rf "$DIST_DIR/.emacs.d/eln-cache" 2>/dev/null || true

# 8. 生成自动安装脚本 (install.sh)
cat > "$DIST_DIR/install.sh" << 'EOF'
#!/bin/bash
set -e

INSTALL_DIR="$HOME/.emacs.d"
BACKUP_DIR="$HOME/.emacs.d.bak.$(date +%s)"
BIN_DIR="$HOME/bin"
FONT_DIR="$HOME/.local/share/fonts"

echo ">>> 🚀 开始部署 Gemini Emacs 配置..."

# 1. 备份旧配置
if [ -d "$INSTALL_DIR" ]; then
    echo ">>> 📦 备份现有配置至 $BACKUP_DIR"
    mv "$INSTALL_DIR" "$BACKUP_DIR"
fi

# 2. 部署新配置
echo ">>> 📂 解压配置文件..."
cp -r .emacs.d "$HOME/"

# 3. 激活离线模式标记
touch "$HOME/.emacs.d/offline"
echo ">>> 🌙 已启用离线模式 (静态加载 elpa & tree-sitter)"

# 4. 安装辅助工具
mkdir -p "$BIN_DIR"
if [ "$(ls -A bin/)" ]; then
    echo ">>> 🛠️ 安装辅助工具 (rg/fd) 至 $BIN_DIR..."
    cp bin/* "$BIN_DIR/"
    chmod +x "$BIN_DIR/"*
fi

# 5. 安装适配字体 (解决终端/GUI 图标乱码)
mkdir -p "$FONT_DIR"
if [ "$(ls -A fonts/)" ]; then
    echo ">>> 🎨 安装字体..."
    cp fonts/* "$FONT_DIR/"
    if command -v fc-cache &> /dev/null; then
        fc-cache -f > /dev/null
    fi
fi

echo ""
echo "============================================================"
echo " ✅ 部署成功！"
echo "============================================================"
echo "1. 请确保 $BIN_DIR 已加入您的 PATH 环境变量。"
echo "2. 重新启动 Emacs 即可享受现代化开发体验。"
EOF

chmod +x "$DIST_DIR/install.sh"

# 8.5 生成 Windows 版自动安装脚本 (install.ps1)
cat > "$DIST_DIR/install.ps1" << 'EOF'
<#
.SYNOPSIS
    Gemini Emacs Offline Installer for Windows
#>
$ErrorActionPreference = 'Stop'
$InstallDir = Join-Path $env:APPDATA ".emacs.d"
$BackupDir = Join-Path $env:APPDATA ".emacs.d.bak.$(Get-Date -UFormat %s)"
$DistDir = $PSScriptRoot

Write-Host ">>> 🚀 开始离线部署 Gemini Emacs 配置 (Windows)..." -ForegroundColor Cyan

# 1. 备份旧配置
if (Test-Path $InstallDir) {
    Write-Host ">>> 📦 备份现有配置至 $BackupDir" -ForegroundColor Yellow
    Rename-Item -Path $InstallDir -NewName $BackupDir
}

# 2. 部署新配置
Write-Host ">>> 📂 复制配置文件..." -ForegroundColor Yellow
Copy-Item -Path (Join-Path $DistDir ".emacs.d") -Destination $env:APPDATA -Recurse -Force

# 3. 激活离线模式标记
$OfflineFlag = Join-Path $InstallDir "offline"
New-Item -Path $OfflineFlag -ItemType File -Force | Out-Null
Write-Host ">>> 🌙 已启用离线模式 (阻止连网更新)" -ForegroundColor Green

# 4. 辅助工具 (可选，Windows 如果没有可以忽略)
$BinDir = Join-Path $InstallDir "bin"
if (-not (Test-Path $BinDir)) { New-Item -ItemType Directory -Path $BinDir | Out-Null }
if (Test-Path (Join-Path $DistDir "bin\*")) {
    Write-Host ">>> 🛠️ 复制辅助工具至 $BinDir..." -ForegroundColor Yellow
    Copy-Item -Path (Join-Path $DistDir "bin\*") -Destination $BinDir -Recurse -Force
}

# 5. 安装字体
$FontDir = Join-Path $DistDir "fonts"
if (Test-Path $FontDir) {
    Write-Host ">>> 🎨 正在安装适配字体..." -ForegroundColor Yellow
    $TargetFontPath = Join-Path $env:windir "Fonts\NFM.ttf"
    if (-not (Test-Path $TargetFontPath)) {
        try {
            Copy-Item -Path (Join-Path $FontDir "NFM.ttf") -Destination $TargetFontPath -Force
            $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            New-ItemProperty -Path $RegPath -Name "JetBrainsMono Nerd Font Mono (TrueType)" -Value "NFM.ttf" -PropertyType String -Force | Out-Null
            Write-Host "✅ 字体安装成功。" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  字体安装失败(可能需要管理员权限运行)。请手动安装 $FontDir 中的字体。" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " ✅ Windows 离线部署成功！" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "直接打开您的 Emacs 即可享受完整离线体验。"
EOF
# 9. 压缩打包
echo ">>> 📦 正在生成最终压缩包..."
rm -f emacs_config_deploy.tar.gz emacs_config_deploy.zip
tar -czf emacs_config_deploy.tar.gz -C "$DIST_DIR" .
if command -v zip &> /dev/null; then
    cd "$DIST_DIR" && zip -r ../emacs_config_deploy.zip . > /dev/null && cd ..
    echo ">>> ✨ 构建完成: emacs_config_deploy.tar.gz (Linux) & emacs_config_deploy.zip (Windows)"
else
    echo ">>> ✨ 构建完成: emacs_config_deploy.tar.gz (建议使用 Windows 10/11 的 tar 命令解压)"
fi
rm -rf "$DIST_DIR"
