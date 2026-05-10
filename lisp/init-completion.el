;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Completion System (Modern Stack)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Vertico: Vertical interactive completion (Minibuffer)
(use-package vertico
  :init
  (vertico-mode)
  :config
  ;; 优化：在 Minibuffer 中按 Backspace 自动删除一级目录
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)
              ("M-q" . vertico-quick-insert)    ;; M-q: 快速插入
              ("C-q" . vertico-quick-exit)))    ;; C-q: 快速选中并退出

;; 1.5 Vertico-Multiform: 自适应布局 (Emacs 30 推荐)
(use-package vertico-multiform
  :ensure nil
  :after vertico
  :init
  (vertico-multiform-mode)
  :config
  ;; 为不同命令设置专属布局
  (setq vertico-multiform-commands
        '((consult-line buffer)           ;; 搜索行时使用列表模式
          (consult-ripgrep buffer)        ;; 全局搜索时使用列表模式
          (consult-find grid))))             ;; 找文件时使用网格模式

;; 2. Orderless: Fuzzy matching for completion
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; 3. Marginalia: Rich annotations in the minibuffer (e.g., file descriptions)
(use-package marginalia
  :config
  (marginalia-mode))

;; 4. Consult: Search and navigation commands (replace built-in switch-to-buffer, etc.)
(use-package consult
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-g f" . consult-flycheck)              ;; 新增：快速跳转错误
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         ;; 项目集成
         ("C-x p b" . consult-project-buffer))
  :init
  ;; 优化 Xref：使用 Consult 界面查找引用和定义 (硬件大规模工程必备)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; 5. Corfu: In-buffer completion popup (Modern & Minimalist)
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                 ;; 开启自动补全
  (corfu-auto-prefix 2)          ;; 输入 2 个字符后开始
  (corfu-auto-delay 0.1)         ;; 延迟 0.1s
  (corfu-quit-at-boundary 'separator) ;; 遇到分隔符时退出
  (corfu-echo-documentation t)   ;; 在回显区显示文档
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous))
  :init
  (global-corfu-mode)
  :config
  ;; 添加图标支持 (Kind-icon: 自动适配主题色的 SVG 图标)
  (use-package kind-icon
    :ensure t
    :after corfu
    :custom
    (kind-icon-default-face 'corfu-default)
    :config
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)))

;; 补全后端扩展 (Cape)
(use-package cape
  :ensure t
  :init
  ;; 增加补全后端：文件名、关键词、Dict 等
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; 6. Embark: Actions at point (The contextual "Right Click")
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; 核心：执行动作
   ("M-." . embark-dwim)        ;; 重新绑定：智能动作 (代替 M-. 以提供增强版跳转)
   ("C-h B" . embark-bindings)) ;; 显示当前模式下的所有按键
  :init
  ;; 替换内置的 help-for-help-map
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; 隐藏一些不需要的动作
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; 集成 Consult 与 Embark
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(provide 'init-completion)
