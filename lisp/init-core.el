;;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Core System Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 0. Warning Suppression (Suppress treesit ABI mismatches & noisy warnings)
(add-to-list 'warning-suppress-types '(treesit))
(add-to-list 'warning-suppress-types '(files))

;; 1. Encoding
;; Set UTF-8 as the default encoding system for everything.
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; 1.5. Path Setup
;; Ensure local bin directory is in the path
(add-to-list 'exec-path (expand-file-name "bin" user-emacs-directory))
(setenv "PATH" (concat (expand-file-name "bin" user-emacs-directory)
                       path-separator
                       (getenv "PATH")))

;; 2. File Management
;; Auto-revert buffers when files change on disk.
(add-hook 'emacs-startup-hook #'global-auto-revert-mode)

;; 记忆光标位置
(add-hook 'emacs-startup-hook #'save-place-mode)
;; 记忆输入历史 (搜索、命令等)
(add-hook 'emacs-startup-hook #'savehist-mode)

;; Disable lockfiles (those .#filename files)
(setq create-lockfiles nil)

;; 3. Auto-Save, Backup & Crash Recovery Management
;; A. 集中管理目录，避免在项目代码仓库里生成乱七八糟的 ~ 和 # 垃圾文件
(let ((backup-dir (expand-file-name "tmp/backups/" user-emacs-directory))
      (autosave-dir (expand-file-name "tmp/auto-saves/" user-emacs-directory)))
  (unless (file-exists-p backup-dir) (make-directory backup-dir t))
  (unless (file-exists-p autosave-dir) (make-directory autosave-dir t))
  (setq backup-directory-alist `(("." . ,backup-dir)))
  (setq auto-save-file-name-transforms `((".*" ,autosave-dir t))))

;; B. 崩溃自动恢复暂存机制 (#filename#)
(setq auto-save-default t          ; 开启自动暂存
      auto-save-timeout 10         ; 10 秒空闲无输入时自动写入暂存
      auto-save-interval 100)      ; 敲击键盘 100 次自动写入暂存

;; C. 原生静默自动存盘 (Auto-Save Visited: 仅对本地文件生效，绝不乱动远程 Tramp 文件)
;; 远程文件必须由用户显式 C-x C-s 保存，防止后台自动存盘与网络死锁引发截断
(defun my/local-file-buffer-p (&optional buffer)
  "Return non-nil if BUFFER visits a local (non-remote) file."
  (let ((file (buffer-file-name (or buffer (current-buffer)))))
    (and file (not (file-remote-p file)))))

(if (fboundp 'auto-save-visited-mode)
    (progn
      (setq auto-save-visited-interval 5)
      (when (boundp 'auto-save-visited-predicate)
        (setq auto-save-visited-predicate #'my/local-file-buffer-p))
      (auto-save-visited-mode 1))
  ;; 兼容旧版本：仅对本地文件执行空闲存盘
  (run-with-idle-timer 5 t
                       (lambda ()
                         (save-some-buffers t #'my/local-file-buffer-p))))

;; D. 周期性全盘保底保存 (每隔 5 分钟定时保存本地文件)
(run-with-timer 300 300
                (lambda ()
                  (save-some-buffers t #'my/local-file-buffer-p)))

;; E. 历史版本文件备份机制 (filename~)
(setq make-backup-files t       ; 启用历史版本备份
      version-control t         ; 启用版本号 (.~1~, .~2~)
      backup-by-copying nil     ; 严禁直接就地截断覆写！改用安全原子重命名，防止写入中断导致原文件被清空
      delete-old-versions t     ; 静默清理过旧版本
      kept-old-versions 6       ; 保留最旧的 6 个版本
      kept-new-versions 9)      ; 保留最新的 9 个版本

;; 4. User Experience & Modern Interactions (Emacs 30+ 专属增强)
;; Answer "y" or "n" instead of "yes" or "no".
(fset 'yes-or-no-p 'y-or-n-p)

;; 允许在选中区域直接输入来替换或包裹内容 (配合 smartparens)
(delete-selection-mode 1)
;; 选区激活时，允许按 Alt+d 或 Alt+Backspace 直接删除选区内容
(put 'kill-word 'delete-selection 'supersede)
(put 'backward-kill-word 'delete-selection 'supersede)

;; 粘贴时剥离外部（浏览器/其他编辑器）携带的背景/字体属性，
;; 避免整段文本出现黄色或彩色的背景高亮块。
(add-to-list 'yank-excluded-properties 'face)
(add-to-list 'yank-excluded-properties 'background)

;; 4.1 现代窗口管理与交互优化 (Emacs 30/31 标配体验)
;; 分割窗口时平均分配可用屏幕空间，避免单向挤压
(setq window-combination-resize t)
;; 打开帮助/文档窗口时自动对焦，按 q 可瞬间关闭返回
(setq help-window-select t)
;; M-x 智能上下文过滤：在当前模式下仅展示有意义且可用的命令 (Emacs 28+)
(setq read-extended-command-predicate #'command-completion-default-include-p)
;; 切换文件时忽略重复警告
(setq find-file-suppress-same-file-warnings t)
;; 快速搜索引用优先使用高性能 ripgrep
(when (executable-find "rg")
  (setq xref-search-program 'ripgrep))

;; 4.2 长文件保护与文本性能优化 (Emacs 29+ 核心优化)
;; 打开包含超长单行的仿真 log、波形输出或压缩文件时自动启用保护，杜绝 Emacs 假死卡死
(when (fboundp 'global-so-long-mode)
  (global-so-long-mode 1))
;; 禁用不适用的双向文字（阿拉伯语/希伯来语等）扫描，大幅提升巨型工程代码的滚动与渲染性能
(setq-default bidi-paragraph-direction 'left-to-right
              bidi-inhibit-bpa t)

;; 4.3 自适应折行缩进对齐 (Emacs 30+ 内置 visual-wrap-prefix-mode)
;; 开启折行后，折下去的文本行自动保持上一行的缩进深度，彻底消除长代码/列表折行的排版撕裂
(when (fboundp 'global-visual-wrap-prefix-mode)
  (global-visual-wrap-prefix-mode 1))

;; 4.4 EditorConfig 原生支持 (Emacs 30+ 官方内置)
;; 自动读取项目根目录下的 .editorconfig 规约缩进、换行风格，跨团队协作免配置
(when (fboundp 'editorconfig-mode)
  (editorconfig-mode 1))

;; 4.5 Tree-sitter 全局现代化映射 (Emacs 29+ / 30 / 31 原生标准机制)
;; 优先使用基于语法树 AST 解析的 -*-ts-mode，性能与语义解析远胜传统正则模式
(let ((ts-dir (expand-file-name "tree-sitter" user-emacs-directory)))
  (when (file-directory-p ts-dir)
    (add-to-list 'treesit-extra-load-path ts-dir)))

(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (require 'treesit)
  (dolist (item '((c-mode          c-ts-mode          c)
                  (c++-mode        c++-ts-mode        cpp)
                  (rust-mode       rust-ts-mode       rust)
                  (yaml-mode       yaml-ts-mode       yaml)
                  (conf-toml-mode  toml-ts-mode       toml)
                  (sh-mode         bash-ts-mode       bash)
                  (python-mode     python-ts-mode     python)
                  (json-mode       json-ts-mode       json)
                  (js-json-mode    json-ts-mode       json)
                  (javascript-mode js-ts-mode         javascript)
                  (js-mode         js-ts-mode         javascript)
                  (typescript-mode typescript-ts-mode typescript)
                  (go-mode         go-ts-mode         go)))
    (let ((orig-mode (nth 0 item))
          (ts-mode   (nth 1 item))
          (lang      (nth 2 item)))
      (when (and (fboundp ts-mode)
                 (treesit-ready-p lang t))
        (add-to-list 'treesit-major-mode-remap-alist (cons orig-mode ts-mode))
        (add-to-list 'major-mode-remap-alist (cons orig-mode ts-mode))))))

;; 4.6 EDA 编译清单与文件列表 (.f / .flist / .vc / .args)
;; GNU Emacs 默认会将 *.f / *.F 绑定为古老的 Fortran 语言 (fortran-mode)。
;; 在芯片设计与 EDA 仿真 (VCS/Verdi/Xcelium/ModelSim/Verilator) 中，*.f 是包含编译选项
;; (+incdir+, +define+) 与源码路径的纯文本文件清单。
;; 重定向为纯文本派生模式，支持 // 与 # 注释，彻底杜绝 Fortran 缩进干扰。
(define-derived-mode eda-filelist-mode text-mode "EDA-Filelist"
  "纯文本 EDA 编译选项与源码文件清单模式 (.f, .flist, .vc, .args)。
保持纯文本行为，同时原生支持 // 与 # 注释语法。"
  (modify-syntax-entry ?/ ". 124b" eda-filelist-mode-syntax-table)
  (modify-syntax-entry ?* ". 23" eda-filelist-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" eda-filelist-mode-syntax-table)
  (modify-syntax-entry ?# "< b" eda-filelist-mode-syntax-table)
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local indent-tabs-mode nil))

(add-to-list 'auto-mode-alist '("\\.[fF]\\'" . eda-filelist-mode))
(add-to-list 'auto-mode-alist '("\\.flist\\'" . eda-filelist-mode))
(add-to-list 'auto-mode-alist '("\\.vc\\'" . eda-filelist-mode))
(add-to-list 'auto-mode-alist '("\\.args\\'" . eda-filelist-mode))
;; 5. Indentation
;; Use spaces instead of tabs and set default width to 4.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq-default c-basic-offset 4)
(setq-default js-indent-level 4)
(setq-default css-indent-offset 4)
(setq-default verilog-indent-level 4)
(setq-default verilog-indent-level-module 4)
(setq-default verilog-indent-level-declaration 4)
(setq-default verilog-indent-level-behavioral 4)
(setq-default rust-indent-offset 4)

;; 6. Compilation Buffer Colors (Hardware Simulation Logs)
(use-package ansi-color
  :ensure nil
  :hook (compilation-filter . ansi-color-compilation-filter))

;; 7. Performance & Cleanliness
(use-package no-littering
  :ensure nil)

;; 持续撤销历史：即使重启 Emacs 也能撤销
(use-package undo-fu-session
  :ensure nil
  :init
  (undo-fu-session-global-mode 1))

(use-package gcmh
  :ensure nil
  :hook (emacs-startup . gcmh-mode)
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-threshold (* 64 1024 1024)))

;; 8. 现代 UI 平滑滚动 (Emacs 30 / PGTK 专属优化)
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

;; 8.5 Repeat-mode: 减少快捷键连按负担
(let ((inhibit-message t))
  (repeat-mode 1))

;; 9. 环境与会话管理 (按需延迟加载)
;; Envrc: 目录环境管理 (direnv 支持，按需启用)
(use-package envrc
  :ensure nil
  :commands (envrc-mode envrc-global-mode))

;; Activities: 现代化的会话/布局管理 (按需加载)
(use-package activities
  :ensure nil
  :defer t
  :bind
  (("C-x C-a C-a" . activities-resume)
   ("C-x C-a C-q" . activities-suspend)
   ("C-x C-a C-s" . activities-save)
   ("C-x C-a C-l" . activities-list)
   ("C-x C-a n"   . activities-new)
   ("C-x C-a g"   . activities-revert))
  :config
  (activities-mode 1)
  (activities-tabs-mode 1))

;; Fix Windows Server Socket Error
(when (eq system-type 'windows-nt)
  (setq server-use-tcp t))

(provide 'init-core)

