;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Tree-sitter Configuration (Modern Parsing)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'treesit)

;; 1. Language Sources
;; Define where to download the grammar parsers from.
(unless (featurep 'init-offline)
  (setq treesit-language-source-alist
        '((c "https://github.com/tree-sitter/tree-sitter-c")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (yaml "https://github.com/ikatyang/tree-sitter-yaml")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (rust "https://github.com/tree-sitter/tree-sitter-rust")
          (toml "https://github.com/tree-sitter/tree-sitter-toml")
          (verilog "https://github.com/tree-sitter/tree-sitter-verilog")
          (systemverilog "https://github.com/gmlarumbe/tree-sitter-systemverilog"))))

;; 2. Mode Remapping
;; Automatically use tree-sitter modes when available.
(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (c-or-c++-mode . c++-ts-mode)
        (yaml-mode . yaml-ts-mode)
        (json-mode . json-ts-mode)
        (python-mode . python-ts-mode)))

;; 3. Helper to install all configured grammars
(defun my/treesit-install-all-grammars ()
  "Install all grammars defined in `treesit-language-source-alist`."
  (interactive)
  (dolist (grammar treesit-language-source-alist)
    (let ((lang (car grammar)))
      (unless (treesit-language-available-p lang)
        (treesit-install-language-grammar lang)))))

(defun my/treesit-install-grammer ()
  "Install all grammars and print logs. (Requested by user with specific name)"
  (interactive)
  (dolist (grammar treesit-language-source-alist)
    (let ((lang (car grammar)))
      (if (treesit-language-available-p lang)
          (message "[Treesit] %s is already installed." lang)
        (message "[Treesit] Installing %s..." lang)
        (condition-case err
            (progn
              (treesit-install-language-grammar lang)
              (message "[Treesit] %s installed successfully." lang))
          (error
           (message "[Treesit] Failed to install %s: %S" lang err)))))))

;; 4. Load Custom Tree-sitter Modes
(require 'verilog-ts-mode)

;; 5. Mode Remapping (Re-enable Verilog)
(add-to-list 'major-mode-remap-alist '(verilog-mode . verilog-ts-mode))

(provide 'init-treesit)
;;; init-treesit.el ends here
