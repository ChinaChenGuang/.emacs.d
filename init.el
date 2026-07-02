;;; package --- Summary
;;; Commentary:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Emacs Configuration Entry Point
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 0. Warning Suppression
(setq native-comp-async-report-warnings-errors 'silent
      byte-compile-warnings nil
      warning-suppress-types '((bytecomp) (native-compiler)))

;; 1. Path Configuration
;;; Add the 'lisp' directory to the load path so we can require our modules.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;;; Add the 'bin' directory to exec-path and PATH for portable executables.
(add-to-list 'exec-path (expand-file-name "bin" user-emacs-directory))
(setenv "PATH" (concat (expand-file-name "bin" user-emacs-directory) ":" (getenv "PATH")))

;; 1.5 Offline Check
(when (file-exists-p (expand-file-name "offline" user-emacs-directory))
  (require 'init-offline))

;; 2. Load Modules (Order Matters)
(require 'init-proxy)       ; Network proxy setup (Must be early)
(require 'init-packages)    ; Package manager setup
(require 'init-core)        ; Core system settings
(require 'init-ui)          ; Visuals, fonts, theme
(require 'init-chinese)     ; Chinese Input Method (Pyim)
(require 'init-completion)  ; Completion framework
(require 'init-dev)         ; Development tools
(require 'init-pi)          ; AI Assistant (Pi & GPTel)
(require 'init-misc)        ; Miscellaneous tools
(require 'init-dashboard)   ; Startup dashboard
(require 'init-markdown)    ; Startup markdown
(require 'init-org)         ; Startup org-mode
(require 'init-treesit)     ; Startup Tree-sitter
(require 'init-lsp)         ; Startup LSP (Eglot)
(require 'init-debug)       ; Startup Debugging (Dape)
(require 'init-cpp)         ; Startup C++ Development
(require 'init-rust)        ; Startup Rust Development
(require 'init-yaml)        ; Startup YAML Development
(require 'init-toml)        ; Startup TOML Development
(require 'init-tcl)         ; Startup Tcl Development
(require 'init-perl)         ; Startup Perl Development
(require 'init-latex)        ; Startup LaTeX Development
(require 'init-verilog)      ; Startup Verilog Development
(require 'init-systemc)      ; Startup SystemC Development

;; 3. Startup Profiler

;; Display startup time and reset GC threshold after initialization.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)
            ;; Reset GC threshold to 2MB for normal operation
            (setq gc-cons-threshold (* 2 1024 1024))))

;; 4. Custom File
;; Keep automatic custom settings in a separate file to keep init.el clean.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; 5. Local configuration
;; Load machine-specific settings that should not be tracked by git.
(let ((local-config (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-config)
    (load local-config)))

;;; init.el ends here
