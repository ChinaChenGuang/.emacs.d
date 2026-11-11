;;; init-dev.el --- Basic Development Tools -*- lexical-binding: t -*-

;; 1. Magit: 基础 Git 客户端
(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  ;; 集成 Magit-todos: 在 Git 状态界面直接显示代码里的 TODO
  (use-package magit-todos
    :ensure nil
    :init
    (magit-todos-mode 1)))

;; 2. Yasnippet: 代码模板 (编程模式按需加载)
(use-package yasnippet
  :ensure nil
  :hook (prog-mode . yas-minor-mode)
  :config
  (use-package yasnippet-snippets :ensure nil)
  (setq yas-wrap-around-region t))

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
  :ensure nil
  :init
  (apheleia-global-mode +1))

;; 5. Tree-sitter AST 代码折叠 (现代语法树折叠引擎，替代陈旧 yafolding)
(require 'init-fold)

;; 6. Sidebar & Code Map: 全局函数/标题侧边栏
(use-package imenu-list
  :ensure nil
  :bind (("C-c i" . imenu-list-smart-toggle)
         :map imenu-list-major-mode-map
         ("f" . imenu-list-goto-entry)) ; 'f' 键跳转并自动收起侧边栏
  :config
  (setq imenu-list-size 30
        imenu-list-position 'left
        imenu-list-auto-resize t       ; 自动根据内容微调宽度
        imenu-list-focus-after-activation t))

;; 6. Eglot: 原生现代化语言服务器客户端 (Emacs 29+ 官方标配)
;; 极简高效、零外部侵入，与 Corfu 补全、Consult 导航和 Xref 完美融合
(use-package eglot
  :ensure nil
  :defer t
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format))
  :config
  ;; 关闭庞大的事件历史日志，换取超大工程下的极致性能
  (setq eglot-events-buffer-size 0)
  ;; 非阻塞异步连接，避免后台卡死输入
  (setq eglot-sync-connect nil)
  ;; 配合 Eldoc 单行或紧凑展示悬停文档
  (setq eldoc-echo-area-use-multiline-p 3))

(provide 'init-dev)
;;; init-dev.el ends here
