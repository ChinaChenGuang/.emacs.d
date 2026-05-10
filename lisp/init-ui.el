;;; -*- lexical-binding: t -*-
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

;; 5.5 Ligatures: 编程连字支持
(use-package ligature
  :ensure t
  :config
  ;; 为所有编程模式启用连字 (适配 JetBrains Mono)
  (ligature-set-ligatures 'prog-mode '("--" "---" "==" "===" "==>" "=>" "=~"
                                       "!=" "!==" "!!" ">=" "<=" ">>" "<<>" ">>>"
                                       "|>" "|->" "-<" "-<<" "<-" "<<" "<-" "<->"
                                       "++" "::" ":::" "==" "&&" "||" "!!" "??"))
  (global-ligature-mode t))

;; 6. Theme (Doom Themes)
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  
  ;; Load the default theme (doom-nord is muted and low-saturation)
  (load-theme 'doom-nord t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
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

;; 7.5 Minions: Hide minor modes for a cleaner look
(use-package minions
  :ensure t
  :config
  (minions-mode 1))

;; 7.6 Tab-bar: 原生工作区/标签栏
(use-package tab-bar
  :ensure nil ; 内置
  :config
  (setq tab-bar-show 1) ; 只有超过1个标签时才显示
  (setq tab-bar-close-button-show nil) ; 隐藏关闭按钮，保持极简
  (setq tab-bar-new-tab-choice "*dashboard*") ; 新标签页默认打开面板
  (tab-bar-mode 1)
  :bind (("C-x t t" . tab-bar-switch-to-next-tab)
         ("C-x t n" . tab-new)
         ("C-x t r" . tab-rename)
         ("C-x t x" . tab-close)
         ("M-[" . tab-bar-switch-to-prev-tab)
         ("M-]" . tab-bar-switch-to-next-tab)))

;; 8. Rainbow Colors
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

;; 12. Highlight Indent Guides: 结构化缩进线
(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :config
  (setq highlight-indent-guides-method 'character) ;; 使用字符模式，最轻量
  (setq highlight-indent-guides-responsive 'focused)) ;; 仅高亮当前代码块

;; 13. Breadcrumb: 面包屑导航 (在顶部显示当前函数/模块路径)
(use-package breadcrumb
  :ensure t
  :init
  (breadcrumb-mode 1))

;; 14. Goggles: 编辑动作的视觉反馈
(use-package goggles
  :ensure t
  :hook (prog-mode . goggles-mode)
  :config
  (setq goggles-pulse t))

;; 15. PDF Tools: 专业数据手册阅读器
(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-annot-activate-created-annotations t)
  ;; 针对低饱和度主题进行颜色反转 (可选)
  ;; (add-hook 'pdf-view-mode-hook #'pdf-view-midnight-minor-mode)
  :bind (:map pdf-view-mode-map
              ("g" . pdf-view-first-page)
              ("G" . pdf-view-last-page)
              ("j" . pdf-view-next-line-or-next-page)
              ("k" . pdf-view-previous-line-or-previous-page)
              ("M-s r" . pdf-occur) ; 搜索 PDF 内容
              ("C-c C-r" . pdf-view-midnight-minor-mode))) ;; 切换午夜/正常模式

;; 10. Popper: Manage "Popup" windows (Help, Compilation, etc.)
;; 让临时窗口不会打乱您的极简布局
(use-package popper
  :ensure t
  :bind (("C-`"   . popper-toggle)      ;; 一键开启/隐藏弹出窗口
         ("M-`"   . popper-cycle)       ;; 在多个弹出窗间循环
         ("C-M-`" . popper-toggle-type)) ;; 将普通窗口设为弹出窗
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Compile-Log\\*"
          "\\*Completions\\*"
          "\\*Warnings\\*"
          "\\*Async Shell Command\\*"
          "\\*Apropos\\*"
          "\\*Backtrace\\*"
          "\\*Eglot events"
          "\\*Flycheck errors\\*"
          help-mode
          compilation-mode))
  (popper-mode 1)
  (popper-echo-mode 1)) ;; 在回显区显示弹出窗列表

;; 11. Pulse: 高亮当前行 (切换窗口时)
(defun my/pulse-momentary-line (&rest _)
  "Pulse the current line momentarily."
  (pulse-momentary-highlight-one-line (point) 'next-error))

(dolist (command '(windmove-do-window-select 
                   winum-select-window-1 winum-select-window-2 
                   winum-select-window-3 winum-select-window-4
                   winum-select-window-5 winum-select-window-6
                   winum-select-window-7 winum-select-window-8
                   avy-goto-char avy-goto-char-timer))
  (advice-add command :after #'my/pulse-momentary-line))

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
