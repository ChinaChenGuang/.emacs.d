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

## ✨ 核心特性
...

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
