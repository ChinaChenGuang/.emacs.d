;;; init-cpp.el --- Basic C/C++ support -*- lexical-binding: t -*-

(use-package cc-mode
  :ensure nil
  :defer t
  :init
  (setq-default c-basic-offset 4)
  (setq c-default-style "linux"))

;; SystemC 文件仍按 C++ 模式打开；SystemC 专属功能见 init-systemc.el
(add-to-list 'auto-mode-alist '("\\.systemc\\'" . c++-mode))

(provide 'init-cpp)
;;; init-cpp.el ends here
