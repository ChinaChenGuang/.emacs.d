;;; init-rust.el --- Basic Rust support -*- lexical-binding: t -*-

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save nil))

(provide 'init-rust)
;;; init-rust.el ends here
