# 🚀 Gemini Emacs Configuration

这是一个高度模块化、性能优化的 Emacs 配置方案，专注于现代开发体验和跨环境（GUI 与终端）的一致性。

## ✨ 现代化编辑器特性

本配置旨在提供媲美现代 IDE 的流畅体验，同时保持 Emacs 的极致灵活性：

### 🔍 现代补全堆栈 (Vertico + Consult)
摒弃了臃肿的传统方案，采用了轻量且强大的现代补全体系：
- **Vertico**: 极简且高效的垂直补全界面。
- **Orderless**: 灵活的模糊匹配算法，支持多模式过滤。
- **Consult**: 提供极其强大的搜索与导航指令（如 `consult-line`, `consult-ripgrep`）。
- **Marginalia**: 在补全列表中实时显示丰富的元数据（如文件大小、函数定义等）。
- **Company**: 极速的代码内补全，支持智能提示。

### 🎨 深度语法支持 (Tree-sitter)
- **原生加速**: 在 Emacs 29+ 环境下自动启用原生 **Tree-sitter** (`-ts-mode`)，提供更精准的语法解析、更快速的高亮以及稳定的结构化编辑。
- **多语言适配**: 针对 C/C++, SystemVerilog, Rust, YAML 等现代开发语言进行了深度优化。

### 🛠 开发者生产力
- **Magit**: 深度集成 Emacs 下最强 Git 客户端，大幅提升 Git 操作效率。
- **Org Mode**: 集成 `org-modern`，提供美观的笔记与项目管理界面。
- **Flycheck**: 实时语法错误检查，确保代码质量。

## 🖥 终端 (-nw) 与 GUI 深度适配

无论是在图形界面还是通过 SSH 连接的终端中，Gemini 都能为您提供一致且舒适的操作体验：

### 🎨 图形化界面 (GUI)
- **精致 UI**: 采用 `doom-one` 主题与 `doom-modeline` 状态栏，兼顾美感与功能。
- **字体优化**: 预设中英文等宽对齐方案（推荐 JetBrains Mono + 微软雅黑），确保表格与布局完美对齐。
- **图标增强**: 全面集成 `nerd-icons`，在文件管理、补全列表和状态栏中展示精美图标。

### ⌨️ 终端模式 (Terminal)
- **轻量稳定**: 针对终端模式（`emacs -nw`）自动禁用重量级视觉特效，确保即使在低带宽或高延迟的 SSH 环境下也能丝滑操作。
- **智能降级**: 自动检测环境并切换图标与字体显示方案，防止在不支持 Nerd Fonts 的终端中出现乱码。
- **快捷交互**: 所有现代化补全与搜索功能在终端中保持完全一致。

## 📦 离线移植与安装

本配置专为离线环境和多机协作设计：

### 1. 联网安装 (Arch Linux/Ubuntu)
```bash
cd ~/.emacs.d && ./setup.sh
```

### 2. 离线环境移植
- **第一步 (联网机器)**: 运行打包脚本生成部署包：
  ```bash
  ./pack_offline.sh
  ```
  该脚本会自动清理二进制缓存（确保跨版本兼容），并生成 `emacs_config_deploy.tar.gz`。
- **第二步 (离线机器)**: 将压缩包拷贝到目标机器并解压运行：
  ```bash
  tar -xzvf emacs_config_deploy.tar.gz
  ./install.sh
  ```
- **特性**: 
  - 自动创建 `~/.emacs.d/offline` 标记文件，使 Emacs 进入**静默离线模式**（禁用联网更新）。
  - 打包已包含所有 `elpa` 插件、兼容性补丁及 `NFM.ttf` 图标字体。

## ⌨️ 常用快捷键

| 快捷键 | 功能 |
| :--- | :--- |
| `M-s r` | 全局搜索 (Ripgrep) |
| `M-s l` | 当前 Buffer 搜索 (Consult line) |
| `M-i`   | 符号高亮 (Symbol Overlay: 开启/关闭当前词高亮) |
| `M-n` / `M-p` | 在高亮的符号间跳转 (后一个/前一个) |
| `M-j`   | 快速跳转 (Avy Timer) |
| `M-s j` | 字符跳转 (Avy Char: 输入1个字符后跳转) |
| `M-g i` | 跳转到符号 (Imenu) |
| `C-x b` | 切换缓冲区 (Consult buffer) |
| `C-x g` | 打开 Magit (Git Status) |
| `C-c x` | 快速切换网络代理 |
| `C->` / `C-.` | 多光标：选中下个相同单词 (自动选中当前词) |
| `C-<` / `C-,` | 多光标：选中上个相同单词 (自动选中当前词) |
| `C-c C-<` | 多光标：选中所有相同单词 |

---
*Created by Gemini for your ultimate Emacs experience.*
