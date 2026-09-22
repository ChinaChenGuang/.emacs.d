;;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Core System Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; C. 原生静默自动存盘 (Auto-Save Visited: 真实保存到文件)
;; 当空闲 5 秒后自动把修改写回真实磁盘文件，彻底杜绝崩溃导致修改丢失
(if (fboundp 'auto-save-visited-mode)
    (progn
      (setq auto-save-visited-interval 5)
      (auto-save-visited-mode 1))
  ;; 兼容旧版本：每 5 秒空闲自动存盘
  (run-with-idle-timer 5 t (lambda () (save-some-buffers t))))

;; D. 周期性全盘保底保存 (每隔 5 分钟定时强制全盘保存一次)
(run-with-timer 300 300 (lambda () (save-some-buffers t)))

;; E. 历史版本文件备份机制 (filename~)
(setq make-backup-files t       ; 启用历史版本备份
      version-control t         ; 启用版本号 (.~1~, .~2~)
      backup-by-copying t       ; 复制备份，不破坏原文件的硬链接和权限
      delete-old-versions t     ; 静默清理过旧版本
      kept-old-versions 6       ; 保留最旧的 6 个版本
      kept-new-versions 9)      ; 保留最新的 9 个版本

;; 4. User Experience
;; Answer "y" or "n" instead of "yes" or "no".
(fset 'yes-or-no-p 'y-or-n-p)

;; 允许在选中区域直接输入来替换或包裹内容 (配合 smartparens)
(delete-selection-mode 1)

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
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-threshold (* 64 1024 1024))
  (gcmh-mode 1))

;; 8. 现代 UI 平滑滚动 (Emacs 30 / PGTK 专属优化)
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

;; 8.5 Repeat-mode: 减少快捷键连按负担
(repeat-mode 1)

;; 9. 环境与会话管理
;; Envrc: 自动加载目录环境 (dirent 支持)
(use-package envrc
  :ensure nil
  :hook (after-init . envrc-global-mode))

;; Activities: 现代化的会话/布局管理
(use-package activities
  :ensure nil
  :init
  (activities-mode 1)
  (activities-tabs-mode 1)
  :bind
  (("C-x C-a C-a" . activities-resume)
   ("C-x C-a C-q" . activities-suspend)
   ("C-x C-a C-s" . activities-save)
   ("C-x C-a C-l" . activities-list)
   ("C-x C-a n"   . activities-new)
   ("C-x C-a g"   . activities-revert)))

;; Fix Windows Server Socket Error
(when (eq system-type 'windows-nt)
  (setq server-use-tcp t))

(provide 'init-core)

