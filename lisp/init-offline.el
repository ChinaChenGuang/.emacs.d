;;; init-offline.el --- Offline Support Configuration -*- lexical-binding: t -*-

;; 1. Disable Package Updates & Auto-Install
(setq use-package-always-ensure nil)     ; Do not try to ensure packages exist (must be pre-installed)
(setq package-archives nil)              ; Clear repositories to prevent connection attempts
(setq auto-package-update-interval nil)  ; Disable auto-update
(eval-after-load 'auto-package-update
  '(fset 'auto-package-update-now (lambda () (message "Auto-update disabled in offline mode."))))

;; 2. Disable Tree-sitter Grammar Downloads
;; Grammars should be pre-installed in the 'tree-sitter/' directory.
(setq treesit-language-source-alist nil)

;; 3. Network & Security Settings
(setq network-security-level 'low) ; Avoid GnuTLS checks that might hang
(setq warning-suppress-types '((comp) (ad-handle-definition))) ; Suppress compilation warnings

;; 4. Mock Icon Downloads
(with-eval-after-load 'nerd-icons
  (defun nerd-icons-install-fonts (&optional _confirm)
    (interactive)
    (message ">>> Offline Mode: Fonts should be installed manually from the 'fonts/' directory.")))

(provide 'init-offline)
;;; init-offline.el ends here
