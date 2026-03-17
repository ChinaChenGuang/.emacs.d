;;; init-tcl.el --- Absolute Basic Tcl support -*- lexical-binding: t -*-

;; 1. 关联文件后缀到正确的函数 tcl-mode
(add-to-list 'auto-mode-alist '("\\.tcl\\'" . tcl-mode))
(add-to-list 'auto-mode-alist '("\\.exp\\'" . tcl-mode))
(add-to-list 'auto-mode-alist '("\\.itcl\\'" . tcl-mode))

;; 2. 基础配置
(with-eval-after-load 'tcl
  (setq tcl-indent-level 4))

(provide 'init-tcl)
;;; init-tcl.el ends here
