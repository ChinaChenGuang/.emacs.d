;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Tree-sitter Configuration (Modern Parsing)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'treesit)

;; 1. Language Sources
;; Define where to download the grammar parsers from.
(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (python "https://github.com/tree-sitter/tree-sitter-python")))

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

(provide 'init-treesit)
;;; init-treesit.el ends here
