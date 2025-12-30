# 🚀 Gemini Emacs Configuration

这是一个高度模块化、性能优化的 Emacs 配置方案，专注于现代开发体验（特别是 C++）和极致的 UI 美感。

## 🚀 项目结构

配置采用模块化设计，所有的核心逻辑都位于 `lisp/` 目录下：

- **`init.el`**: 配置入口，负责加载各模块并计算启动时间。
...

## 📦 安装与初始化

在一个新的 Linux 环境中，只需运行根目录下的初始化脚本即可自动安装所有依赖（包括 C++ 编译器、Ripgrep 和 Verible LSP）：

```bash
cd ~/.emacs.d
./setup.sh
```

脚本会自动检测系统包管理器 (apt/pacman) 并安装必要的软件。

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
