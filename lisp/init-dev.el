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
  :init (global-flycheck-mode))

(provide 'init-dev)
;;; init-dev.el ends here
