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
(set-face-background 'hl-line "#3B4252")

;; 4. Fonts Configuration (English + Chinese Alignment)
(defun my/setup-fonts ()
  "Setup English and Chinese fonts with proper alignment."
  (when (display-graphic-p)
    ;; A. English Font (Default)
    (let ((font-candidates '("JetBrains Mono" "Cascadia Code" "Consolas" "Monospace"))
          (font-size 16) ;; Customize size here
          (found-font nil))
      (dolist (font font-candidates)
        (when (and (not found-font) (member font (font-family-list)))
          (setq found-font font)))
      
      (if found-font
          (set-face-attribute 'default nil :font (format "%s-%d" found-font font-size))
        (when (display-graphic-p)
          (message "Warning: No preferred English font found."))))

    ;; B. Chinese Font (Fallback for Han characters)
    ;; We set a specific font for Chinese and a 'rescale' ratio to ensure
    ;; 1 Chinese char = 2 English chars (for Org tables alignment).
    (let ((zh-candidates '("Microsoft YaHei" "SimHei" "Noto Sans CJK SC" "PingFang SC"))
          (zh-found nil))
      (dolist (font zh-candidates)
        (when (and (not zh-found) (member font (font-family-list)))
          (setq zh-found font)
          ;; Set this font for CJK characters
          (set-fontset-font t 'han (font-spec :family font))
          (set-fontset-font t 'symbol (font-spec :family font))
          (set-fontset-font t 'cjk-misc (font-spec :family font))
          (set-fontset-font t 'bopomofo (font-spec :family font))
          
          ;; Alignment Magic:
          ;; Scale Chinese font by 1.25x to match JetBrains Mono's width.
          ;; If you use Consolas, 1.2 might work better.
          ;; If tables are still misaligned, tweak this number (e.g., 1.2, 1.3).
          (add-to-list 'face-font-rescale-alist (cons font 1.15)))))))

;; Apply fonts after UI init
(add-hook 'after-init-hook #'my/setup-fonts)
(add-hook 'server-after-make-frame-hook #'my/setup-fonts)

;; 5. Icons Support
(use-package nerd-icons
  :ensure t
  :config
  ;; Fix for missing SystemVerilog icons (using FontAwesome microchip icon which is more stable)
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
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 30
        ;; Only show icons in GUI mode to prevent garbled text in remote terminals
        doom-modeline-icon (display-graphic-p)
        doom-modeline-checker-simple-format t)) ;; Use text for flycheck instead of icons to avoid font issues

;; 8. Rainbow Colors
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

;; 9. Tech Stack Status (Tree-sitter & LSP)
(defun my/get-tech-stack-status ()
  "Return a formatted string showing Tree-sitter and LSP status."
  (let ((ts (if (and (fboundp 'treesit-parser-list) (treesit-parser-list)) 
                (propertize "TS" 'face '(:inherit success :weight bold))
              (propertize "TS" 'face '(:inherit shadow))))
        (lsp (if (bound-and-true-p lsp-mode)
                 (propertize "LSP" 'face '(:inherit success :weight bold))
               (propertize "LSP" 'face '(:inherit shadow)))))
    (format " [%s|%s] " ts lsp)))

(add-to-list 'global-mode-string '(:eval (my/get-tech-stack-status)) t)

(provide 'init-ui)
;;; init-ui.el ends here
