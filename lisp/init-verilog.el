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
  (setq-local verilog-indent-lists 2)
  
  ;; verilog-ts-mode specific (Tree-sitter)
  (setq-local verilog-ts-indent-level 2)
  
  ;; Ensure spaces instead of tabs
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 2)
  (setq-local backward-delete-char-untabify-method 'hungry)

  ;; 2. Disable Auto-newline after semicolon
  (setq-local verilog-auto-newline nil)
  (setq-local verilog-auto-lineup nil))

;; Apply to Classic Verilog Mode (Stable & Basic)
(use-package verilog-mode
  :ensure nil ; Built-in
  :mode ("\\.v\\'" "\\.sv\\'" "\\.svh\\'")
  :hook ((verilog-mode . my/verilog-style-setup)
         (verilog-ts-mode . my/verilog-style-setup))
  :bind (:map verilog-mode-map
              ("C-c v" . my/verilog-menu)) ; 定义控制中心快捷键
  :config
  (setq verilog-indent-level 2)
  (setq verilog-indent-level-module 2)
  (setq verilog-indent-level-declaration 2)
  (setq verilog-indent-level-behavioral 2)
  (setq verilog-indent-level-directive 2)
  (setq verilog-case-indent 2)
  (setq verilog-auto-newline nil))

;; ----------------------------------------------------------------------
;; Verilog Control Center (Transient)
;; ----------------------------------------------------------------------
(use-package transient
  :ensure t
  :config
  (transient-define-prefix my/verilog-menu ()
    "Main Menu for Verilog Development."
    ["--- AUTO Expansion ---"
     ("a" "Expand AUTOs" verilog-auto)
     ("d" "Delete AUTOs" verilog-delete-auto)
     ("i" "Inject AUTOs" verilog-inject-auto)]
    ["--- Code Quality ---"
     ("l" "Flycheck List" flycheck-list-errors)
     ("v" "Verilator Lint" (lambda () (interactive) (compile "verilator --lint-only -Wall %f")))
     ("f" "LSP Format" eglot-format)
     ("r" "LSP Rename" eglot-rename)]
    ["--- Documentation ---"
     ("h" "Header Template" verilog-header)]
    ["--- Build & Sim ---"
     ("c" "Compile / Lint" compile)
     ("w" "GTKWave" (lambda () (interactive) (start-process "gtkwave" nil "gtkwave")))
     ("s" "Shell" eat)]))

;; Tree-sitter specific enhancement for Verilog
(use-package verilog-ts-mode
  :defer t
  :config
  (setq verilog-ts-indent-level 2))

(provide 'init-verilog)
;;; init-verilog.el ends here
