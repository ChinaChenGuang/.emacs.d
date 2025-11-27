;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UI/UX Configuration - Optimized
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ----------------------------------------------------------------------
;; 1. Basic UI Cleanup
;; ----------------------------------------------------------------------
;; Disable startup message, go directly to Scratch buffer
(setq inhibit-startup-message t)

;; Turn off unnecessary GUI elements to maximize screen space
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))   ; Disable tool bar
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))   ; Disable menu bar (enable if needed)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)) ; Disable scroll bar

;; ----------------------------------------------------------------------
;; 2. Line Numbers
;; ----------------------------------------------------------------------
;; Enable line numbers globally
(global-display-line-numbers-mode t)

;; Disable line numbers in specific modes (e.g., shell, eshell, tree-sitter, etc.)
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; ----------------------------------------------------------------------
;; 3. Font Configuration
;; ----------------------------------------------------------------------
;; Attempt to set a good programming font. If not installed on the system, this step is ignored.
;; You can change "JetBrains Mono" or "Source Code Pro" to your preferred font.
(let ((my-font "JetBrains Mono"))
  (when (member my-font (font-family-list))
    (set-face-attribute 'default nil :font (concat my-font " 13"))))

;; ----------------------------------------------------------------------
;; 4. Theme Configuration
;; ----------------------------------------------------------------------
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings: Enable bold and italics
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  
  ;; Load the doom-one theme
  (load-theme 'doom-one t)

  ;; Visual Bell: Flash the screen on error instead of making an audio beep
  (doom-themes-visual-bell-config)
  
  ;; Org Mode beautification: Make Org headers and lists look modern
  (doom-themes-org-config))

;; ----------------------------------------------------------------------
;; 5. Highlighting & Cursor
;; ----------------------------------------------------------------------
;; Enable current line highlighting
(global-hl-line-mode 1)

;; Customize highlight color (Nord dark grey)
;; Note: If you switch to a Light Theme in the future, it is recommended to comment out the line below,
;; because this dark grey will look stark on a white background.
(set-face-background 'hl-line "#3B4252")

;; Enable parenthesis matching (highlight the matching parenthesis when cursor is on one)
(show-paren-mode 1)

(provide 'init-ui)
;;; init-ui.el ends here
