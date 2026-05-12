;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Miscellaneous Tools & Smart Editing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Which-key: Displays available keybindings in popup
(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

;; 2. Recentf: Track recent files
(use-package recentf
  :init (recentf-mode 1)
  :config
  (setq recentf-max-menu-items 25
        recentf-max-saved-items 25))

;; 3. Smartparens: Auto-pairing & Jumping
(use-package smartparens
  :ensure t
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config)
  ;; SystemVerilog Support
  (sp-with-modes '(verilog-mode)
    (sp-local-pair "begin" "end"         :actions '(insert navigate))
    (sp-local-pair "class" "endclass"    :actions '(insert navigate))
    (sp-local-pair "module" "endmodule"  :actions '(insert navigate))
    (sp-local-pair "task" "endtask"      :actions '(insert navigate))
    (sp-local-pair "function" "endfunction" :actions '(insert navigate))
    (sp-local-pair "covergroup" "endgroup" :actions '(insert navigate)))
  :bind
  (:map smartparens-mode-map
        ("C-M-f" . sp-forward-sexp)
        ("C-M-b" . sp-backward-sexp)
        ("C-%" . my/smart-jump-match)))

;; Custom Helper Function for "Magic Jump" (C-%)
(defun my/smart-jump-match ()
  "Smartly jump to the matching parenthesis or keyword."
  (interactive)
  (cond
   ((looking-at "\\s\(") (sp-forward-sexp))
   ((looking-at "\\s\)") (sp-backward-sexp))
   ((derived-mode-p 'verilog-mode)
    (let ((pt (point)))
      (verilog-forward-sexp)
      (when (= pt (point))
        (verilog-backward-sexp))))
   (t (sp-backward-up-sexp))))

;; ----------------------------------------------------------------------
;; 4. Avy: Fast Cursor Movement (Jump to anywhere)
;; ----------------------------------------------------------------------
(use-package avy
  :ensure t
  :bind (("M-j"   . avy-goto-char-timer)
         ("M-s j" . avy-goto-char)
         ("M-s w" . avy-goto-word-1)
         ("M-g l" . avy-goto-line))
  :config
  (setq avy-timeout-seconds 0.3
        avy-all-windows t))

;; ----------------------------------------------------------------------
;; 5. Winum & Window Management
;; ----------------------------------------------------------------------
(use-package winum
  :ensure t
  :init (winum-mode)
  :bind (("M-1" . winum-select-window-1)
         ("M-2" . winum-select-window-2)
         ("M-3" . winum-select-window-3)
         ("M-4" . winum-select-window-4)
         ("M-5" . winum-select-window-5)
         ("M-6" . winum-select-window-6)
         ("M-7" . winum-select-window-7)
         ("M-8" . winum-select-window-8)
         ("M-0" . winum-select-window-0-or-10)))

;; ----------------------------------------------------------------------
;; 6. Crux: A collection of Ridiculously Useful eXtensions
;; ----------------------------------------------------------------------
(use-package crux
  :ensure t
  :bind (("C-a"   . crux-move-beginning-of-line)
         ("C-c d" . crux-duplicate-current-line-or-region)
         ("C-c M-d" . crux-duplicate-and-comment-current-line-or-region)
         ("C-c k" . crux-kill-whole-line)
         ("C-c o" . crux-smart-open-line-above)
         ("C-c O" . crux-smart-open-line)
         ("C-c r" . crux-rename-file-and-buffer)
         ("C-c t" . crux-visit-term-buffer)
         ("C-c N" . crux-cleanup-buffer-or-region)
         ("C-c f" . crux-recentf-find-file)
         ("C-c D" . crux-delete-file-and-buffer)))

;; ----------------------------------------------------------------------
;; 7. Expand Region: Semantic selection
;; ----------------------------------------------------------------------
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

;; ----------------------------------------------------------------------
;; 8. Dirvish: Modern File Manager (Dired Enhancement)
;; ----------------------------------------------------------------------
(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-quick-access-entries
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads"                "Downloads")
     ("o" "~/org"                      "Org")
     ("p" "~/projects"                 "Projects")))
  (dirvish-mode-line-format
   '(:left (sort symlink) :right (omit yank index)))
  (dirvish-attributes
   '(nerd-icons file-size collapse git-msg))
  :bind
  ;; 代替传统的 dired-jump，现在按 C-x C-j 会打开一个华丽的 Dirvish 窗口
  (("C-x C-j" . dirvish-dwim)
   ("C-x j"   . dirvish-dwim)
   :map dirvish-mode-map ; Dirvish 内部快捷键
   ("a"   . dirvish-quick-access)
   ("f"   . dirvish-file-info-menu)
   ("y"   . dirvish-yank-menu)
   ("N"   . dirvish-narrow)
   ("^"   . dirvish-history-last)
   ("h"   . dirvish-history-jump) ; 最近访问的目录
   ("s"   . dirvish-quicksort)    ; 排序
   ("TAB" . dirvish-subtree-toggle) ;; 像侧边栏一样展开目录
   ("M-t" . dirvish-layout-toggle)))

;; ----------------------------------------------------------------------
;; 9. Multiple Cursors: Edit multiple lines/matches simultaneously
;; ----------------------------------------------------------------------
;; 使用官方推荐的 symbol 系列命令，可以精确匹配整个单词/符号，避免误选子字符串
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-c C-<"     . mc/mark-all-symbols-like-this)
         ("C-M-m"       . mc/mark-all-dwim)
         ("C->"         . mc/mark-next-symbol-like-this)
         ("C-<"         . mc/mark-previous-symbol-like-this)
         ("C-."         . mc/mark-next-symbol-like-this)
         ("C-,"         . mc/mark-previous-symbol-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

;; ----------------------------------------------------------------------
;; 8. Symbol Overlay: Highlight symbols and jump between them
;; ----------------------------------------------------------------------
;; Usage:
;; - M-i : Toggle highlight for symbol at point
;; - n / p : Move to next/previous highlight (when overlay is active)
;; - M-s n / M-s p : Global jump to next/previous occurrence
(use-package symbol-overlay
  :ensure t
  :bind (("M-i" . symbol-overlay-put)
         ("M-n" . symbol-overlay-jump-next)
         ("M-p" . symbol-overlay-jump-prev)
         ("M-s n" . symbol-overlay-switch-forward)
         ("M-s p" . symbol-overlay-switch-backward))
  :hook (prog-mode . symbol-overlay-mode))

;; ----------------------------------------------------------------------
;; 10. Vundo: Visual Undo Tree
;; ----------------------------------------------------------------------
(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo)
  :config
  (setq vundo-glyph-alist vundo-unicode-symbols)
  ;; 限制 vundo 窗口高度，保持极简
  (setq vundo-window-side 'bottom))

;; ----------------------------------------------------------------------
;; 11. wgrep: Writable Grep buffers
;; ----------------------------------------------------------------------
(use-package wgrep
  :ensure t
  :config
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-change-readonly-file t))

;; ----------------------------------------------------------------------
;; 12. Eat: Modern Terminal Emulator (Emulate A Terminal)
;; ----------------------------------------------------------------------
(use-package eat
  :ensure t
  :bind (("C-c t" . eat)
         :map eat-mode-map
         ("M-j" . avy-goto-char-timer)) ;; 允许在终端内使用 avy
  :config
  (setq eat-kill-buffer-on-exit t)
  (setq eat-term-name "xterm-256color")
  ;; 启用 Corfu 支持
  (add-hook 'eat-mode-hook #'corfu-mode))

;; ----------------------------------------------------------------------
;; 13. diff-hl: Show Git changes in the fringe
;; ----------------------------------------------------------------------
(use-package diff-hl
  :ensure t
  :hook ((after-init . global-diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; 如果在终端下，自动切换到 margin 模式显示
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1)))

;; ----------------------------------------------------------------------
;; 14. Ace-window: Better window navigation
;; ----------------------------------------------------------------------
(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-scope 'frame))

;; ----------------------------------------------------------------------
;; 15. Helpful: A better help system
;; ----------------------------------------------------------------------
(use-package helpful
  :ensure t
  :bind (([remap describe-function] . helpful-callable)
         ([remap describe-command]  . helpful-command)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-key]      . helpful-key)
         ([remap describe-symbol]   . helpful-symbol)
         ("C-c C-d" . helpful-at-point)))

;; ----------------------------------------------------------------------
;; 16. Jinx: High-performance spell checker
;; ----------------------------------------------------------------------
(use-package jinx
  :ensure t
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :init
  ;; 默认不全局开启拼写检查，避免满屏幕波浪线。
  ;; (global-jinx-mode 1)
  )

;; ----------------------------------------------------------------------
;; 17. Dogears: Location history (The modern "Jump Back")
;; ----------------------------------------------------------------------
(use-package dogears
  :ensure t
  :hook (after-init . dogears-mode)
  :bind (("M-g d" . dogears-go)
         ("M-g p" . dogears-prev)
         ("M-g n" . dogears-next)
         ("M-g l" . dogears-list))
  :config
  (setq dogears-limit 200) ;; 记录最近 200 个位置
  (setq dogears-idle 1))   ;; 闲置 1 秒后记录当前位置

;; 6. Embark: Actions at point (The contextual "Right Click")
;; 已在 init-completion.el 中配置

;; ----------------------------------------------------------------------
;; 18. Iedit: Simultaneous editing (Local refactoring)
;; ----------------------------------------------------------------------
(use-package iedit
  :ensure t
  :bind (("C-;" . iedit-mode)    ;; 全文相同符号同时编辑
         ("C-x r ;" . iedit-rectangle-mode))) ;; 矩形区域编辑

;; ----------------------------------------------------------------------
;; 19. Custom Editing Utilities (Move Lines)
;; ----------------------------------------------------------------------
(defun my/move-line-up ()
  "Move the current line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun my/move-line-down ()
  "Move the current line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key (kbd "M-<up>") 'my/move-line-up)
(global-set-key (kbd "M-<down>") 'my/move-line-down)

(provide 'init-misc)
;;; init-misc.el ends here
