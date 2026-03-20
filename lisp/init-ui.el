;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UI/UX Configuration - Adaptable for Terminal & GUI
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Clean UI
(setq inhibit-startup-message t)
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Enable CUA Selection Mode (Standard Copy/Paste & Rectangles)
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

;; 4. Fonts Configuration (English + Chinese Alignment)
(defun my/setup-fonts ()
  "Setup English and Chinese fonts with proper alignment."
  (when (display-graphic-p)
    ;; A. English Font (Default)
    (let ((font-candidates '("JetBrainsMono Nerd Font Mono" "JetBrains Mono" "Cascadia Code" "Consolas" "Monospace"))
          (font-size 16)
          (found-font nil))
      (dolist (font font-candidates)
        (when (and (not found-font) (member font (font-family-list)))
          (setq found-font font)))
      
      (if found-font
          (set-face-attribute 'default nil :font (format "%s-%d" found-font font-size))
        (message "Warning: No preferred English font found.")))

    ;; B. Chinese Font (Alignment Magic)
    (let ((zh-candidates '("Noto Sans CJK SC" "Microsoft YaHei" "SimHei" "PingFang SC"))
          (zh-found nil))
      (dolist (font zh-candidates)
        (when (and (not zh-found) (member font (font-family-list)))
          (setq zh-found font)
          (set-fontset-font t 'han (font-spec :family font))
          (set-fontset-font t 'cjk-misc (font-spec :family font))
          (set-fontset-font t 'bopomofo (font-spec :family font))
          (add-to-list 'face-font-rescale-alist (cons font 1.2)))))))

;; Apply fonts after UI init
(add-hook 'after-init-hook #'my/setup-fonts)
(add-hook 'server-after-make-frame-hook #'my/setup-fonts)

;; 5. Icons Support
(use-package nerd-icons
  :ensure t
  :config
  ;; Fallback mapping for SystemVerilog
  (add-to-list 'nerd-icons-extension-icon-alist
               '("svh" nerd-icons-faicon "nf-fa-microchip" :face nerd-icons-blue))
  (add-to-list 'nerd-icons-extension-icon-alist
               '("sv"  nerd-icons-faicon "nf-fa-microchip" :face nerd-icons-blue)))

;; 6. Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; 7. Modeline (Status Bar)
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 30
        ;; Automatically disable icons in terminal to prevent garbled text
        doom-modeline-icon (display-graphic-p)
        doom-modeline-checker-simple-format t))

;; 8. Rainbow Colors
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

;; 9. Tech Stack Status (Tree-sitter Focused)
(defun my/get-tech-stack-status ()
  "Return a formatted string showing Tree-sitter status."
  (let ((ts (if (and (fboundp 'treesit-parser-list) (treesit-parser-list)) 
                (propertize "TS" 'face '(:inherit success :weight bold))
              (propertize "TS" 'face '(:inherit shadow)))))
    (format " [%s] " ts)))

(add-to-list 'global-mode-string '(:eval (my/get-tech-stack-status)) t)

(provide 'init-ui)
;;; init-ui.el ends here
