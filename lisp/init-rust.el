;;; init-rust.el --- Modern Rust support (Tree-sitter First) -*- lexical-binding: t -*-

(if (and (fboundp 'treesit-ready-p)
         (treesit-ready-p 'rust t))
    (use-package rust-ts-mode
      :ensure nil
      :mode "\\.rs\\'"
      :config
      (setq rust-ts-mode-indent-offset 4))
  (use-package rust-mode
    :ensure nil
    :mode "\\.rs\\'"
    :config
    (setq rust-format-on-save nil)))

(provide 'init-rust)
;;; init-rust.el ends here
