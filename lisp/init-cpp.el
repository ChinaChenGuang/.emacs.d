;;; init-cpp.el --- Modern C/C++ & SystemC support -*- lexical-binding: t -*-

;; 1. 传统 CC 模式兜底
(use-package cc-mode
  :ensure nil
  :defer t
  :init
  (setq-default c-basic-offset 4)
  (setq c-default-style "linux"))

;; 2. 现代 Tree-sitter 原生模式配置 (c-ts-mode / c++-ts-mode, Emacs 29+ 内置)
(with-eval-after-load 'c-ts-mode
  (setq c-ts-mode-indent-offset 4
        c-ts-mode-indent-style 'linux))

;; SystemC 文件仍按 C++ 模式打开；SystemC 专属功能见 init-systemc.el
(add-to-list 'auto-mode-alist '("\\.systemc\\'" . c++-mode))

(provide 'init-cpp)
;;; init-cpp.el ends here
