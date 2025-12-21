;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; C/C++ Development Configuration (Arch Linux Optimized)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. 使用 Emacs 30 内置的 Tree-sitter 模式以获得更强的性能
(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (c-or-c++-mode . c++-ts-mode)))

(use-package cc-mode
  :ensure nil
  :bind (:map c++-mode-map
              ("C-c C-p" . compile)       ; 延续之前的编译快捷键
         :map c++-ts-mode-map
              ("C-c C-p" . compile))
  :config
  (setq-default c-basic-offset 4)
  ;; Linux 下推荐使用项目根目录的 Makefile，如果没有则默认 g++
  (setq compile-command "make -k"))

;; 2. LSP 智能补全 (Arch 环境下配合 clangd)
(use-package lsp-mode
  :ensure t
  :hook ((c-ts-mode c++-ts-mode) . lsp-deferred)
  :commands lsp
  :config
  (setq lsp-idle-delay 0.1
        lsp-enable-symbol-highlighting t
        lsp-enable-indentation t
        lsp-headerline-breadcrumb-enable t))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t))

;; 3. DAP-Mode 图形化调试 (Arch Linux 安装 gdb 即可使用)
(use-package dap-mode
  :ensure t
  :config
  (dap-auto-configure-mode)
  (require 'dap-gdb-lldb)
  ;; 如果是 Arch Linux, gdb 通常在 /usr/bin/gdb
  (dap-gdb-lldb-setup)
  :bind (:map c++-ts-mode-map
              ("<f5>" . dap-debug)
              ("C-c d b" . dap-breakpoint-toggle)))

;; 4. 编译输出窗口优化
(setq compilation-scroll-output t)
(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter))

;; 5. CMake 支持
(use-package cmake-mode
  :ensure t)

(provide 'init-cpp)
;;; init-cpp.el ends here
