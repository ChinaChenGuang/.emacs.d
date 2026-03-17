;;; init-treesit.el --- Tree-sitter Disabled -*- lexical-binding: t -*-

<<<<<<< HEAD
;; 0. Early Version Check
(if (or (version< emacs-version "29.1")
        (not (and (fboundp 'treesit-available-p)
                  (treesit-available-p))))
    (message ">>> Skipping Native Tree-sitter: Emacs version %s is too old (Requires 29.1+) or not compiled with support." emacs-version)

  (require 'treesit)
  
  ;; 0. Global Tree-sitter Settings
  (defvar treesit-load-name-override-list nil)
  (add-to-list 'treesit-load-name-override-list 
               '(verilog "libtree-sitter-systemverilog" "tree_sitter_systemverilog"))

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
            (verilog "https://github.com/gmlarumbe/tree-sitter-systemverilog") ; Use systemverilog grammar for verilog-ts-mode
            (systemverilog "https://github.com/gmlarumbe/tree-sitter-systemverilog"))))

  ;; 2. Mode Remapping Helper
  (defun my/treesit-remap-if-available (old-mode new-mode lang)
    "Remap OLD-MODE to NEW-MODE if LANG grammar is available."
    (if (treesit-language-available-p lang)
        (add-to-list 'major-mode-remap-alist (cons old-mode new-mode))
      (message "[Treesit] Grammar for %s not found, skipping remap of %s to %s." lang old-mode new-mode)))

  ;; Automatically use tree-sitter modes when available.
  (my/treesit-remap-if-available 'c-mode 'c-ts-mode 'c)
  (my/treesit-remap-if-available 'c++-mode 'c++-ts-mode 'cpp)
  (my/treesit-remap-if-available 'c-or-c++-mode 'c++-ts-mode 'cpp)
  (my/treesit-remap-if-available 'yaml-mode 'yaml-ts-mode 'yaml)
  (my/treesit-remap-if-available 'json-mode 'json-ts-mode 'json)
  (my/treesit-remap-if-available 'python-mode 'python-ts-mode 'python)

  ;; 3. Helper to install all configured grammars
  (defun my/treesit-install-all-grammars ()
    "Install all grammars defined in `treesit-language-source-alist`."
    (interactive)
    (dolist (grammar treesit-language-source-alist)
      (let ((lang (car grammar)))
        (unless (treesit-language-available-p lang)
          (treesit-install-language-grammar lang)))))

  (defun my/treesit-install-grammar ()
    "Install all grammars and print logs."
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

  ;; 4. Custom Tree-sitter Modes
  (use-package verilog-ts-mode
    :ensure t)

  ;; 5. Mode Remapping (Re-enable Verilog)
  (my/treesit-remap-if-available 'verilog-mode 'verilog-ts-mode 'verilog))
=======
;; Tree-sitter 动态编译和重定向已禁用。
;; 回归到传统的内置语法高亮模式。
>>>>>>> dd5389e (config: simplify development environment and add basic Tcl/Perl support)

(provide 'init-treesit)
;;; init-treesit.el ends here
