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
对于多目录的 SystemVerilog/UVM 项目，**必须**生成文件索引列表 LSP 才能精准工作：

1. 进入你的工程根目录 (例如 `cd ~/my_uvm_project`)。
2. 运行构建脚本：
   ```bash
   ~/.emacs.d/bin/gen-verible-project.sh
   ```
   这会生成 `verible.filelist` 文件，解决 "include not found" 和跨文件跳转失败的问题。
3. 在 Emacs 中重启 LSP: `M-x lsp-workspace-restart`。

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
