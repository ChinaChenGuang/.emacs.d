;;; init-cpp.el --- Basic C/C++ support -*- lexical-binding: t -*-

(use-package cc-mode
  :ensure nil
  :config
  (setq-default c-basic-offset 4)
  (setq c-default-style "linux"))

<<<<<<< HEAD
;; 快捷键绑定 (针对 Emacs 30 Tree-sitter 优化)
(with-eval-after-load 'c-ts-mode
  (define-key c-ts-mode-map (kbd "C-c C-p") #'compile)
  (define-key c++-ts-mode-map (kbd "C-c C-p") #'compile))

;; ----------------------------------------------------------------------------
;; 3. LSP 智能补全
;; ----------------------------------------------------------------------------
(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode c-ts-mode c++-ts-mode) . lsp-deferred)
  :commands lsp
  :config
  (setq lsp-idle-delay 0.1
        lsp-enable-symbol-highlighting t
        lsp-enable-indentation t
        lsp-headerline-breadcrumb-enable t)
  
  ;; Disable auto-guess-root so we can manually select 'src' folder for UVM/Verilog projects
  (setq lsp-auto-guess-root nil)
  (setq lsp-file-watch-threshold 5000)
  
  (setq lsp-language-id-configuration (delete '(emacs-lisp-mode . "emacs-lisp") lsp-language-id-configuration)))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t))

;; ----------------------------------------------------------------------------
;; 4. DAP-Mode 图形化调试
;; ----------------------------------------------------------------------------
(use-package dap-mode
  :ensure t
  :commands dap-debug
  :config
  (dap-auto-configure-mode)
  (with-eval-after-load 'dap-mode
    (require 'dap-gdb-lldb)
    (condition-case nil
        (dap-gdb-lldb-setup)
      (error (message "DAP: Notice - Automatic gdb-lldb setup skipped, using system GDB."))))
  
  (with-eval-after-load 'c++-ts-mode
    (define-key c++-ts-mode-map (kbd "<f5>") #'dap-debug)
    (define-key c++-ts-mode-map (kbd "C-c d b") #'dap-breakpoint-toggle)))

;; ----------------------------------------------------------------------------
;; 5. 编译输出窗口优化
;; ----------------------------------------------------------------------------
(setq compilation-scroll-output t)
(use-package ansi-color
  :hook (compilation-filter . ansi-color-compilation-filter))

;; ----------------------------------------------------------------------------
;; 6. CMake 支持
;; ----------------------------------------------------------------------------
(use-package cmake-mode
  :ensure t)
=======
;; SystemC 关联到 C++ 模式
(add-to-list 'auto-mode-alist '("\\.systemc\\'" . c++-mode))
>>>>>>> dd5389e (config: simplify development environment and add basic Tcl/Perl support)

(provide 'init-cpp)
;;; init-cpp.el ends here
