;;; init-dev.el --- Basic Development Tools -*- lexical-binding: t -*-

;; 1. Magit: 基础 Git 客户端
(use-package magit
  :bind ("C-x g" . magit-status))

;; 2. SystemVerilog 基础配置
(use-package verilog-mode
  :ensure nil ; 内置
  :mode ("\\.v\\'" "\\.sv\\'" "\\.svh\\'")
  :config
  (setq verilog-indent-level 4)
  (setq verilog-indent-level-module 4)
  (setq verilog-indent-level-declaration 4)
  (setq verilog-indent-level-behavioral 4)
  (setq verilog-indent-level-directive 4)
  (setq verilog-case-indent 4)
  (setq verilog-auto-newline nil))

;; 3. 基础语法检查 (如果有外部工具如 cppcheck/flake8)
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  ;; 禁用 flycheck 中的 org-lint 检查器，避免报错和兼容性问题
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers '(org-lint))))

;; 4. yafolding: 基于缩进的折叠工具
(use-package yafolding
  :ensure t
  :bind (("C-c y" . yafolding-toggle-element)
         ("C-c Y" . yafolding-toggle-all))
  :hook ((prog-mode text-mode conf-mode) . yafolding-mode))

;; 5. Sidebar & Code Map: 全局函数/标题侧边栏
(use-package imenu-list
  :ensure t
  :bind (("C-c t" . imenu-list-smart-toggle)
         :map imenu-list-major-mode-map
         ("f" . imenu-list-goto-entry)) ; 'f' 键跳转并自动收起侧边栏
  :config
  (setq imenu-list-size 30
        imenu-list-position 'left
        imenu-list-auto-resize t       ; 自动根据内容微调宽度
        imenu-list-focus-after-activation t))

(provide 'init-dev)
;;; init-dev.el ends here
