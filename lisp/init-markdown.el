;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Markdown Support
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)   ; Use GitHub Flavored Markdown for READMEs
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  ;; Set the default command to generate HTML (if you have pandoc or markdown installed)
  (setq markdown-command "markdown")
  
  :hook
  ;; Enable visual-line-mode for soft wrapping (text wraps at window edge)
  (markdown-mode . visual-line-mode)
  
  :config
  ;; 1. Header Styling
  ;; Scale header sizes to make the document structure visually clear
  (setq markdown-header-scaling t)
  (setq markdown-header-scaling-values '(1.6 1.4 1.2 1.1 1.0 1.0))

  ;; 2. Code Block Styling
  ;; Use native syntax highlighting for code blocks inside markdown
  (setq markdown-fontify-code-blocks-natively t)
  
  ;; 3. Keybindings
  ;; Custom bindings can be added here if needed
  ;; Default useful keys:
  ;; C-c C-c p  -> Preview in browser
  ;; C-c C-c e  -> Export to HTML
  ;; Tab        -> Fold/Unfold current section
  )

(provide 'init-markdown)
;;; init-markdown.el ends here
