;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; YAML Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'init-packages)
(require 'init-treesit)

;; 1. Base Mode (Generic YAML support)
(use-package yaml-mode
  :ensure t
  :mode ("\.ya?ml\'" . yaml-mode))

;; 2. Tree-sitter Mode (Modern Syntax Highlighting)
;; yaml-ts-mode is built-in to Emacs 29+.
;; init-treesit.el handles the remapping from yaml-mode to yaml-ts-mode.
(use-package yaml-ts-mode
  :ensure nil ; Built-in
  :hook (yaml-ts-mode . lsp-deferred) ; Enable LSP automatically
  :config
  ;; Additional tree-sitter configuration if needed
  )

;; 3. LSP Support for YAML
;; Requires: npm install -g yaml-language-server
;; lsp-yaml is part of the lsp-mode package, so we don't ensure it separately.
(use-package lsp-yaml
  :ensure nil
  :after lsp-mode
  :config
  (setq lsp-yaml-schemas
        '((kubernetes . ["k8s/*.yaml" "kube/*.yaml" "*.k8s.yaml"]))))

(provide 'init-yaml)
;;; init-yaml.el ends here
