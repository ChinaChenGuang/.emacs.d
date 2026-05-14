;;; init-dev.el --- Basic Development Tools -*- lexical-binding: t -*-

;; 1. Magit: 基础 Git 客户端
(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  ;; 集成 Magit-todos: 在 Git 状态界面直接显示代码里的 TODO
  (use-package magit-todos
    :ensure t
    :init
    (magit-todos-mode 1)))

;; 2. Yasnippet: 代码模板
(use-package yasnippet
  :ensure t
  :hook (after-init . yas-global-mode)
  :config
  (use-package yasnippet-snippets :ensure t)
  ;; 允许 Snippet 包裹选中区域 (使用 $1 或 $0 占位符)
  (setq yas-wrap-around-region t)
  ;; 在 Corfu 补全列表中集成 Yasnippet
  (with-eval-after-load 'cape
    (add-to-list 'completion-at-point-functions #'cape-dict)
    (add-to-list 'completion-at-point-functions #'yas-capf)))

;; 3. 基础语法检查
(use-package flycheck
  :init 
  ;; 默认不全局开启，避免满屏波浪线。可以根据需要在使用的地方局部开启 (flycheck-mode)
  ;; (global-flycheck-mode)
  :config
  ;; 禁用 flycheck 中的 org-lint 检查器，避免报错和兼容性问题
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers '(org-lint))))

;; 4. Apheleia: 异步自动格式化 (保存时自动对齐)
(use-package apheleia
  :ensure t
  :init
  (apheleia-global-mode +1)
  :config
  ;; 配置 Verilog 格式化器 (优先使用 verible-verilog-format)
  (setf (alist-get 'verilog-ts-mode apheleia-mode-alist) 'verible-verilog-format)
  (setf (alist-get 'verilog-mode apheleia-mode-alist) 'verible-verilog-format))

;; 5. yafolding: 基于缩进的折叠工具
(use-package yafolding
  :ensure t
  :bind (("C-c y" . yafolding-toggle-element)
         ("C-c Y" . yafolding-toggle-all))
  :hook ((prog-mode text-mode conf-mode) . yafolding-mode))

;; 5. Sidebar & Code Map: 全局函数/标题侧边栏
(use-package imenu-list
  :ensure t
  :bind (("C-c i" . imenu-list-smart-toggle)
         :map imenu-list-major-mode-map
         ("f" . imenu-list-goto-entry)) ; 'f' 键跳转并自动收起侧边栏
  :config
  (setq imenu-list-size 30
        imenu-list-position 'left
        imenu-list-auto-resize t       ; 自动根据内容微调宽度
        imenu-list-focus-after-activation t))

(provide 'init-dev)
;;; init-dev.el ends here
