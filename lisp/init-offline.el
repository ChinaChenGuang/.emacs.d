;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Offline Mode Configuration
;; Loaded automatically if 'offline.flag' exists or explicitly required.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(message ">>> OFFLINE MODE ACTIVATED: Network features disabled.")

;; 1. Disable Package Updates & Auto-Install
(setq use-package-always-ensure nil)     ; Do not try to ensure packages exist (must be pre-installed)
(setq package-archives nil)              ; Clear repositories to prevent connection attempts
(setq auto-package-update-interval nil)  ; Disable auto-update
(eval-after-load 'auto-package-update
  '(fset 'auto-package-update-now (lambda () (message "Auto-update disabled in offline mode."))))

;; 2. Disable Tree-sitter Grammar Downloads
;; Prevent attempting to download grammars.
(setq treesit-language-source-alist nil) 

;; 3. Disable LSP Server Downloads
;; Prevent LSP from asking to download servers.
(setq lsp-auto-configure t)
(setq lsp-enable-snippet t)
(with-eval-after-load 'lsp-mode
  (setq lsp-server-install-dir (expand-file-name "bin/" user-emacs-directory))
  ;; Force specific clients to use local binaries if needed, 
  ;; though standard clients usually check PATH first.
  )

;; 4. Misc Network Disables
(setq network-security-level 'low) ; Avoid GnuTLS checks that might hang
(setq warning-suppress-types '((comp) (ad-handle-definition))) ; Suppress compilation warnings

(provide 'init-offline)
