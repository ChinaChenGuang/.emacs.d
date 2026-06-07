;;; init-lsp.el --- LSP Support using Eglot -*- lexical-binding: t -*-

;; 1. Eglot (Built-in LSP client)
(use-package eglot
  :ensure nil ; Built-in in Emacs 29+
  :hook ((c-mode          . eglot-ensure)
         (c++-mode        . eglot-ensure)
         (c-ts-mode       . eglot-ensure)
         (c++-ts-mode     . eglot-ensure)
         (rust-ts-mode    . eglot-ensure)
         (python-ts-mode  . eglot-ensure)
         (verilog-mode    . eglot-ensure)
         (verilog-ts-mode . eglot-ensure))
  :config
  ;; 配置 LSP 服务器
  ;; 为 Verilog/SystemVerilog 添加支持
  (add-to-list 'eglot-server-programs
               '((verilog-mode verilog-ts-mode) . ("verible-verilog-ls" "--profpath" ".")))
  
  ;; 性能优化
  (setq eglot-events-buffer-size 0)
  (setq eglot-autoshutdown t)
  
  ;; 配合 Eldoc-box 使用：更现代的悬浮文档
  (use-package eldoc-box
    :ensure t
    :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode)
    :config
    (setq eldoc-box-max-pixel-width 600
          eldoc-box-max-pixel-height 400))
  
  ;; 快捷键
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l f" . eglot-format)
              ("C-c l a" . eglot-code-actions)
              ("C-c l h" . eldoc)))

  ;; 3. Dumb-jump: 强力跳转回退
  ;; 当 LSP 无法识别某些宏或头文件时，Dumb-jump 通过正则进行全项目搜索
  (use-package dumb-jump
  :ensure t
  :init
  ;; 将 dumb-jump 插入 xref 后端
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :config
  (setq dumb-jump-selector 'completing-read) ;; 使用 Vertico 界面
  (setq dumb-jump-prefer-searcher 'rg))       ;; 使用 Ripgrep 提升速度

(with-eval-after-load 'eglot
  (setq completion-category-defaults nil))

(provide 'init-lsp)
;;; init-lsp.el ends here
