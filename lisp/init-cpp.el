;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; C/C++ Development Configuration (Arch Linux Optimized)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Tree-sitter 语法库源配置
(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))

;; 将传统的 c-mode 和 c++-mode 重定向到新的 ts-mode
(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (c-or-c++-mode . c++-ts-mode)))

;; ----------------------------------------------------------------------------
;; 2. 智能编译配置 (Smart Compilation)
;; ----------------------------------------------------------------------------
(defun my/cpp-set-compile-command ()
  "Determine the best compile command for the current buffer."
  (unless (or (file-exists-p "Makefile") (file-exists-p "makefile"))
    (let ((file (file-name-nondirectory buffer-file-name)))
      (setq-local compile-command
                  (format "g++ -g -Wall -Wextra %s -o %s"
                          file
                          (file-name-sans-extension file))))))

(use-package cc-mode
  :ensure nil
  :hook ((c-mode c++-mode c-ts-mode c++-ts-mode) . my/cpp-set-compile-command)
  :config
  (setq-default c-basic-offset 4))

;; 快捷键绑定 (针对 Emacs 30 Tree-sitter 优化)
(with-eval-after-load 'c-ts-mode
  (define-key c-ts-mode-map (kbd "C-c C-p") #'compile)
  (define-key c++-ts-mode-map (kbd "C-c C-p") #'compile))

;; ----------------------------------------------------------------------------
;; 3. LSP 智能补全
;; ----------------------------------------------------------------------------
(use-package lsp-mode
  :ensure t
  :hook ((c-ts-mode c++-ts-mode) . lsp-deferred)
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

(provide 'init-cpp)
;;; init-cpp.el ends here
