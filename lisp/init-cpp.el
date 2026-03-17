;;; init-cpp.el --- Basic C/C++ support -*- lexical-binding: t -*-

(use-package cc-mode
  :ensure nil
  :config
  (setq-default c-basic-offset 4)
  (setq c-default-style "linux"))

;; SystemC 关联到 C++ 模式
(add-to-list 'auto-mode-alist '("\\.systemc\\'" . c++-mode))

(provide 'init-cpp)
;;; init-cpp.el ends here
