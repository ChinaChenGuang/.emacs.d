;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Verilog & SystemVerilog Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/verilog-style-setup ()
  "Custom style for Verilog and SystemVerilog."
  ;; 1. Indentation Settings (Set to 2 spaces)
  (setq-local verilog-indent-level 2)
  (setq-local verilog-indent-level-module 2)
  (setq-local verilog-indent-level-declaration 2)
  (setq-local verilog-indent-level-behavioral 2)
  (setq-local verilog-indent-level-directive 2)
  (setq-local verilog-case-indent 2)
  (setq-local verilog-cexp-indent 2)
  
  ;; Ensure spaces instead of tabs
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 2)

  ;; 2. Disable Auto-newline after semicolon
  ;; In verilog-mode, this is controlled by verilog-auto-newline
  (setq-local verilog-auto-newline nil)
  
  ;; If using electric features, disable the specific ones that cause jumps
  (setq-local verilog-auto-lineup nil))

;; Apply to Classic Verilog Mode
(use-package verilog-mode
  :ensure nil ; Built-in
  :hook (verilog-mode . my/verilog-style-setup))

;; Apply to Modern Tree-sitter Verilog Mode
(use-package verilog-ts-mode
  :ensure t
  :hook (verilog-ts-mode . my/verilog-style-setup)
  :config
  ;; verilog-ts-mode specific indentation
  (setq-local verilog-ts-indent-level 2))

(provide 'init-verilog)
;;; init-verilog.el ends here
