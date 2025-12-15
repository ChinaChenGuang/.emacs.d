;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Emacs Configuration Entry Point
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Path Configuration
;; Add the 'lisp' directory to the load path so we can require our modules.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; 2. Load Modules (Order Matters)
(require 'init-packages)    ; Package manager setup (Must be first)
(require 'init-core)        ; Core system settings
(require 'init-ui)          ; Visuals, fonts, theme
(require 'init-completion)  ; Completion framework
(require 'init-dev)         ; Development tools
(require 'init-misc)        ; Miscellaneous tools
(require 'init-dashboard)   ; Startup dashboard
(require 'init-markdown)    ; Startup markdown
(require 'init-org)         ; Startup org-mode
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
