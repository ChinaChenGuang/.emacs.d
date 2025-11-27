;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UI/UX Configuration - Refactored & Robust
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ----------------------------------------------------------------------
;; 1. System & Behavior (Startup & Scrolling)
;; ----------------------------------------------------------------------

;; Disable the default startup screen
(setq inhibit-startup-message t)

;; Clean up the UI: Disable toolbar, menubar, and scrollbar for more space
;; We use `fboundp` to ensure these functions exist before calling them.
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Improve scrolling behavior: make it smooth and keep context
(setq scroll-margin 2                    ; Keep 2 lines of context at top/bottom
      scroll-conservatively 101          ; Scroll line-by-line instead of jumping
      scroll-preserve-screen-position t) ; Keep cursor position relative to screen

;; Display startup statistics in the echo area after loading
(defun my/display-startup-time ()
  "Display Emacs startup time and GC count in the echo area."
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'my/display-startup-time)

;; ----------------------------------------------------------------------
;; 2. Visual Basics (Line Numbers, Highlighting)
;; ----------------------------------------------------------------------

;; Enable line numbers globally
(global-display-line-numbers-mode t)

;; Disable line numbers in specific modes where they are unnecessary
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                treemacs-mode-hook
                vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Highlight the current line (with robust color setting later)
(global-hl-line-mode 1)

;; Highlight matching parentheses
(show-paren-mode 1)

;; ----------------------------------------------------------------------
;; 3. Fonts & Icons
;; ----------------------------------------------------------------------

;; Set programming font (only in GUI mode to prevent terminal errors)
(when (display-graphic-p)
  (let ((my-font "JetBrains Mono")
        (my-font-size 13))
    (when (member my-font (font-family-list))
      (set-face-attribute 'default nil :font (format "%s-%d" my-font my-font-size)))))

;; Icons support (run `M-x nerd-icons-install-fonts` if icons are missing)
(use-package nerd-icons
  :ensure t)

;; ----------------------------------------------------------------------
;; 4. Theme Configuration
;; ----------------------------------------------------------------------

(use-package doom-themes
  :ensure t
  :config
  ;; Enable bold and italic text
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  
  ;; Load the specific theme
  (load-theme 'doom-one t)
  
  ;; Use visual bell instead of audio beep
  (doom-themes-visual-bell-config)
  
  ;; Improve Org Mode headings and lists
  (doom-themes-org-config))

;; Customize the line highlight color for the chosen theme
;; Note: #3B4252 is a dark grey from the Nord palette
(set-face-background 'hl-line "#3B4252")

;; ----------------------------------------------------------------------
;; 5. Modeline (Status Bar)
;; ----------------------------------------------------------------------

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  ;; Adjust modeline height for a sleeker look
  (setq doom-modeline-height 30)
  ;; Ensure icons are displayed if available
  (setq doom-modeline-icon t))

;; ----------------------------------------------------------------------
;; 6. Advanced Visualization (Rainbows)
;; ----------------------------------------------------------------------

;; Colorize nested parentheses to make Lisp/Scheme easier to read
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Colorize color codes (e.g., show #ffffff as white background)
(use-package rainbow-mode
  :ensure t
  :hook (prog-mode . rainbow-mode))

(provide 'init-ui)
;;; init-ui.el ends here
