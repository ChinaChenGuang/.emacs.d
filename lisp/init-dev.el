;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 开发环境配置 (Development Environment)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ----------------------------------------------------------------------
;; 现代代码补全 (Modern Completion) - Company Mode
;; ----------------------------------------------------------------------
(use-package company
  :after diminish
  :diminish company-mode
  :config
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 2)
  (add-hook 'after-init-hook 'global-company-mode))

;; ----------------------------------------------------------------------
;; LSP 客户端 (LSP Client) - Eglot (内置)
;; ----------------------------------------------------------------------
(use-package eglot
  :ensure nil ; Emacs 29+ built-in
  :hook
  (python-mode . eglot-ensure)
  (verilog-mode . eglot-ensure)
  :config
  (setq eglot-autoshutdown t))

;; ----------------------------------------------------------------------
;; Python & SystemVerilog 特定配置
;; ----------------------------------------------------------------------
(use-package python-mode
  :mode "\\.py\\'"
  :interpreter "python3")

(use-package verilog-mode
  :mode ("\\.v\\'" . verilog-mode)
        ("\\.sv\\'" . verilog-mode))

(provide 'init-dev)
;;; init-dev.el ends here
