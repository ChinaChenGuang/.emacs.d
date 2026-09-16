<#
.SYNOPSIS
    setup.ps1 - Initialize Gemini Emacs Environment for Windows
.DESCRIPTION
    Installs dependencies, fonts, and tools (Verible) for Emacs on Windows.
#>

$ErrorActionPreference = 'Stop'
$EmacsDir = $PSScriptRoot
$BinDir = Join-Path $EmacsDir "bin"

if (-not (Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir | Out-Null
}

Write-Host "🚀 Initializing Gemini Emacs Environment for Windows..." -ForegroundColor Cyan

# 1. System Dependencies Warning
Write-Host "📦 Checking system dependencies..." -ForegroundColor Yellow
$MissingDeps = @()
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) { $MissingDeps += "git" }
if (-not (Get-Command "rg" -ErrorAction SilentlyContinue)) { $MissingDeps += "ripgrep" }

if ($MissingDeps.Count -gt 0) {
    Write-Host "⚠️  Missing tools: $($MissingDeps -join ', ')" -ForegroundColor Red
    Write-Host "   Please install them via Winget or Scoop, for example:"
    Write-Host "   winget install Git.Git BurntSushi.ripgrep.MSVC"
} else {
    Write-Host "✅ Git and Ripgrep are installed." -ForegroundColor Green
}

# 2. Font Setup
Write-Host "🅰️  Installing Nerd Fonts (NFM.ttf)..." -ForegroundColor Yellow
$FontPath = Join-Path $EmacsDir "fonts\NFM.ttf"
if (Test-Path $FontPath) {
    $FontName = "JetBrainsMono Nerd Font Mono" # Name approximation
    $TargetFontPath = Join-Path $env:windir "Fonts\NFM.ttf"
    
    if (-not (Test-Path $TargetFontPath)) {
        try {
            Copy-Item -Path $FontPath -Destination $TargetFontPath -Force
            # Add registry key so Windows knows about the font
            $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            New-ItemProperty -Path $RegPath -Name "$FontName (TrueType)" -Value "NFM.ttf" -PropertyType String -Force | Out-Null
            Write-Host "✅ Font installed successfully. (You may need to restart apps to see it)" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Failed to install font automatically. Please Right-Click $FontPath and select 'Install'." -ForegroundColor Red
        }
    } else {
        Write-Host "✅ Font is already installed." -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  NFM.ttf not found in fonts\ directory." -ForegroundColor Red
}

# 3. Install Verible (SystemVerilog LSP)
Write-Host "🛠  Setting up Verible (SystemVerilog LSP) for Windows..." -ForegroundColor Yellow
$VeribleExe = Join-Path $BinDir "verible-verilog-ls.exe"

if (-not (Test-Path $VeribleExe)) {
    Write-Host "   Downloading Verible..."
    $VeribleUrl = "https://github.com/chipsalliance/verible/releases/download/v0.0-4051-g9fdb4057/verible-v0.0-4051-g9fdb4057-win64.zip"
    $ZipPath = Join-Path $env:TEMP "verible.zip"
    $ExtractPath = Join-Path $env:TEMP "verible_extracted"

    Invoke-WebRequest -Uri $VeribleUrl -OutFile $ZipPath
    
    if (Test-Path $ExtractPath) { Remove-Item -Recurse -Force $ExtractPath }
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force

    # Find the bin folder inside the extracted archive and copy executables
    $ExtractedBin = Get-ChildItem -Path $ExtractPath -Directory -Recurse | Where-Object { $_.Name -eq 'bin' }
    if ($ExtractedBin) {
        Copy-Item -Path "$($ExtractedBin.FullName)\*.exe" -Destination $BinDir -Force
        Write-Host "✅ Verible installed to $BinDir" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to extract Verible executables." -ForegroundColor Red
    }

    Remove-Item $ZipPath -Force
    Remove-Item -Recurse -Force $ExtractPath
} else {
    Write-Host "✅ Verible already installed." -ForegroundColor Green
}

# 4. Create local.el Placeholder
$LocalEl = Join-Path $EmacsDir "local.el"
if (-not (Test-Path $LocalEl)) {
    ";; Local configuration for this machine" | Out-File -FilePath $LocalEl -Encoding UTF8
    Write-Host "✅ Created local.el (ignored by git)" -ForegroundColor Green
}

# 5. Finalize
Write-Host "🎉 Setup Complete!" -ForegroundColor Cyan
Write-Host "   Next steps:"
Write-Host "   1. Ensure this folder is at %APPDATA%\.emacs.d (or your HOME\.emacs.d)."
Write-Host "   2. Open Emacs, it will automatically download packages."
Write-Host "   3. Use 'C-c x' to toggle proxy if download is slow."
Write-Host "   4. Put machine-specific settings in 'local.el'."
