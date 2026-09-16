;;; init-rust.el --- Basic Rust support -*- lexical-binding: t -*-

(use-package rust-mode
  :ensure nil
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save nil))

(provide 'init-rust)
;;; init-rust.el ends here
