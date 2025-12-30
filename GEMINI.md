# 🚀 Gemini Emacs Configuration

这是一个高度模块化、性能优化的 Emacs 配置方案，专注于现代开发体验（特别是 C++）和极致的 UI 美感。

## 🚀 项目结构

配置采用模块化设计，所有的核心逻辑都位于 `lisp/` 目录下：

- **`init.el`**: 配置入口，负责加载各模块并计算启动时间。
...

## 📦 安装与初始化

### 1. 环境安装
在一个新的 Linux 环境中，只需运行根目录下的初始化脚本即可自动安装所有依赖：

```bash
cd ~/.emacs.d
./setup.sh
```

### 2. SystemVerilog 工程初始化 (修复跳转问题)
SystemVerilog LSP (Verible) 需要知道项目的文件结构才能跨目录跳转。

**场景：阅读 UVM 源码或多目录验证环境**
如果遇到 `M-.` 无法跳转到基类定义，或提示 "File not found"：

1. **进入工程/源码根目录**:
   打开终端，cd 到您的项目根目录（如果是看 UVM 源码，就进入 UVM 的解压目录）。

2. **生成索引文件**:
   运行配置自带的脚本：
   ```bash
   ~/.emacs.d/bin/gen-verible-project.sh
   ```
   这会在当前目录下生成 `verible.filelist`，自动递归加入所有子目录到 Include Path。

3. **生效**:
   - 在 Emacs 中打开任意 `.sv` 文件。
   - 如果 LSP 已经在运行，执行命令：`M-x lsp-workspace-restart`。

### 3. LSP Workspace 管理与 Include 跳转

**Q: 如何管理 LSP Workspace?**
LSP 会自动识别项目根目录，但如果需要手动管理（例如添加外部库目录）：
- `M-x lsp-workspace-folders-add`: 添加新的根目录到当前会话。
- `M-x lsp-workspace-folders-remove`: 移除根目录。
- `M-x lsp-describe-session`: 查看当前 LSP 连接状态和 Workspace 信息。

**Q: 如何跳转进入 include 文件?**
- **方法 1 (推荐)**: 光标移动到文件名上，按 `M-.` (Go to definition)。如果 `verible.filelist` 配置正确，LSP 会处理。
- **方法 2 (备用)**: 按 `C-c f` (Find File At Point)。这是 Emacs 原生功能，会自动识别光标下的路径并打开。

## ✨ 核心特性

### 🎨 极致视觉 (UI/UX)
- **主题**: 使用 `doom-one` 主题搭配 `doom-modeline`。
- **图标**: 全面集成 `nerd-icons` (含 SystemVerilog 图标支持)。
- **字体**: 经过精心配置的中英文等宽对齐方案（默认 JetBrains Mono + 微软雅黑）。
- **彩虹特效**: `rainbow-delimiters` 让括号嵌套一目了然。
- **Org 笔记**: 
    - 集成 `org-modern`，提供 Notion 风格的标题、列表和元数据徽章。
    - 使用 `visual-fill-column` 提供舒适的居中阅读体验。
    - `valign` 完美解决中英文混排表格对齐问题。

### 🔍 现代补全系统
摒弃了臃肿的 Ivy/Helm，采用了轻量且强大的现代堆栈：
- **Vertico**: 垂直交互式补全。
- **Marginalia**: 在补全列表中显示丰富的元数据注解。
- **Consult**: 提供极其强大的搜索与导航指令（如 `consult-line`, `consult-ripgrep`）。
- **Orderless**: 灵活的模糊匹配算法。
- **Company**: 极速的代码内补全。

### 🛠 开发者工具
- **Tree-sitter**: 深度集成 Emacs 30 的原生语法解析库，提供更精准的代码高亮与跳转。
- **C++ 特化**: 
    - 自动识别 `Makefile` 或生成智能编译指令。
    - `LSP & DAP`: 完整的 C++ 语言服务器支持与图形化调试 (GDB/LLDB) 集成。
    - `CMake`: 完善的 CMake 项目支持。
- **SystemVerilog**:
    - **LSP 支持**: 集成 **Verible** Language Server，提供精准的**定义跳转**、引用查找和错误提示。
    - **工具路径**: Verible 二进制文件已自动安装至 `~/.emacs.d/bin/`。
    - **备用方案**: 保留 `dumb-jump` + `ripgrep` 作为 LSP 未启动时的后备方案。
    - **结构**: 针对 SystemVerilog 的代码折叠与导航优化。
- **Git**: 深度集成 `Magit`（Emacs 下最强 Git 客户端）。

## ⌨️ 常用快捷键 (部分)

| 快捷键 | 功能 |
| :--- | :--- |
| `M-s r` | 全局搜索 (Ripgrep) - **SystemVerilog 推荐** |
| `M-s l` | 当前 Buffer 搜索 (Consult line) |
| `M-.` | 跳转到定义 (Go to definition) |
| `M-?` | 查找引用 (Find references) |
| `M-g i` | 跳转到符号 (Imenu) |
| `C-x b` | 切换缓冲区 (Consult buffer) |
| `C-c C-p` | 快速编译 (C++ 模式下) |
| `<f5>` | 启动 DAP 调试 |
| `C-c d b` | 切换断点 |
| `C-c h` | 历史记录检索 |

---
*Created by Gemini for your ultimate Emacs experience.*
