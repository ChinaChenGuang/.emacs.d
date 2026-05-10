;;; init-debug.el --- Debug Adapter Protocol Support (Dape) -*- lexical-binding: t -*-

;; 1. Dape (Debug Adapter Protocol for Emacs)
;; 现代化的调试客户端，类似 Eglot 的设计哲学
(use-package dape
  :ensure t
  :bind (("<f5>" . dape-continue)
         ("<f9>" . dape-breakpoint-toggle)
         ("<f10>" . dape-next)
         ("<f11>" . dape-step-in)
         ("<S-f11>" . dape-step-out)
         ("C-x t d" . dape)
         ("C-x t q" . dape-kill))
  :config
  ;; 自动开启提示
  (add-hook 'dape-on-start-functions 'dape-info-widgets-setup)
  
  ;; 配合 Popper 管理调试窗口
  (with-eval-after-load 'popper
    (add-to-list 'popper-reference-buffers "\\*dape-.*\\*"))

  ;; 默认配置：为 C++ (gdb) 增加一些默认项
  (add-to-list 'dape-configs
               `(gdb-debug
                 modes (c-mode c++-mode c-ts-mode c++-ts-mode)
                 command "gdb"
                 command-args ("--interpreter=dap")
                 :request "launch"
                 :program "a.out")))

(provide 'init-debug)
;;; init-debug.el ends here
