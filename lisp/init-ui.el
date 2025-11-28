;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UI/UX Configuration - Windows Optimized
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Clean UI
(setq inhibit-startup-message t)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))



;; Enable CUA Selection Mode
;; Allows typing over selection and using C-RET for rectangle selection.
;; Note: This does not interfere with standard Emacs copy/paste keys.
(cua-selection-mode 1)

;; 2. Smooth Scrolling
(setq scroll-margin 2
      scroll-conservatively 101
      scroll-preserve-screen-position t)

;; 3. Line Numbers & Highlighting
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(global-hl-line-mode 1)
(show-paren-mode 1)

;; 4. Fonts (Robust logic)
(when (display-graphic-p)
  (let ((font-candidates '("JetBrains Mono" "Cascadia Code" "Source Code Pro" "Menlo" "Consolas" "Monospace"))
        (my-font-size 16) ; Increased font size from 13 to 16
        (found-font nil))
    (dolist (font font-candidates)
      (when (and (not found-font) (member font (font-family-list)))
        (setq found-font font)))
    
    (if found-font
        (set-face-attribute 'default nil :font (format "%s-%d" found-font my-font-size))
      (message "Warning: No preferred programming font found."))))

;; 5. Icons Support
(use-package nerd-icons
  :ensure t)

;; 6. Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(set-face-background 'hl-line "#3B4252")

;; 7. Modeline (Status Bar)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 30
        doom-modeline-icon t))

;; 8. Rainbow Colors
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(provide 'init-ui)
