# 🚀 Gemini Emacs Configuration

这是一个高度模块化、性能优化的 Emacs 配置方案，专注于现代开发体验（特别是 C++）和极致的 UI 美感。

## 📂 项目结构

配置采用模块化设计，所有的核心逻辑都位于 `lisp/` 目录下：

- **`init.el`**: 配置入口，负责加载各模块并计算启动时间。
- **`early-init.el`**: 早期初始化，用于优化启动性能（如禁用不必要的 UI 元素）。
- **`lisp/`**: 核心模块目录：
    - `init-packages.el`: 宏包管理与 `use-package` 配置。
    - `init-ui.el`: 视觉效果、主题（Doom One）、字体对齐（中英等宽）。
    - `init-completion.el`: 现代补全全家桶（Vertico + Consult + Orderless）。
    - `init-dev.el` & `init-cpp.el`: 编程环境与 C++ 特化支持（LSP, DAP）。
    - `init-org.el`: Org-mode 增强。
    - `init-dashboard.el`: 个性化启动界面。

## ✨ 核心特性

### 🎨 极致视觉 (UI/UX)
- **主题**: 使用 `doom-one` 主题搭配 `doom-modeline`。
- **图标**: 全面集成 `nerd-icons`。
- **字体**: 经过精心配置的中英文等宽对齐方案（默认 JetBrains Mono + 微软雅黑）。
- **彩虹特效**: `rainbow-delimiters` 让括号嵌套一目了然。

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
    - **跳转**: 开箱即用的 `M-.` (定义) 和 `M-?` (引用) 支持 (基于 `dumb-jump`)。
    - **性能**: 集成 `ripgrep` 以实现毫秒级的大型项目符号搜索。
    - **结构**: 针对 SystemVerilog 的代码折叠与导航优化。
- **Git**: 深度集成 `Magit`（Emacs 下最强 Git 客户端）。
- **项目管理**: 使用 `treemacs` 进行文件树浏览。

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
