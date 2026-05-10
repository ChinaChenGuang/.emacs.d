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
(global-auto-revert-mode t)

;; 记忆光标位置
(save-place-mode 1)
;; 记忆输入历史 (搜索、命令等)
(savehist-mode 1)

;; Disable lockfiles (those .#filename files)
(setq create-lockfiles nil)

;; 3. Backup Management
;; Store all backup files in a centralized directory instead of cluttering project folders.
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(setq make-backup-files t       ; Enable backups
      version-control t         ; Use version numbers for backups
      backup-by-copying t       ; Copy instead of renaming
      delete-old-versions t     ; Delete old versions silently
      kept-old-versions 6       ; Keep 6 oldest versions
      kept-new-versions 9)      ; Keep 9 newest versions

;; 4. User Experience
;; Answer "y" or "n" instead of "yes" or "no".
(fset 'yes-or-no-p 'y-or-n-p)

;; Silence native-compilation warnings popup
(setq native-comp-async-report-warnings-errors 'silent)

;; 5. Indentation
;; Use spaces instead of tabs and set default width to 2.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default standard-indent 2)

;; 6. Compilation Buffer Colors (Hardware Simulation Logs)
(use-package ansi-color
  :ensure nil
  :hook (compilation-filter . ansi-color-compilation-filter))

;; 7. Performance & Cleanliness
(use-package no-littering
  :ensure t)

;; 持续撤销历史：即使重启 Emacs 也能撤销
(use-package undo-fu-session
  :ensure t
  :init
  (undo-fu-session-global-mode 1))

(use-package gcmh
  :ensure t
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
  :ensure t
  :hook (after-init . envrc-global-mode))

;; Activities: 现代化的会话/布局管理
(use-package activities
  :ensure t
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

(provide 'init-core)
