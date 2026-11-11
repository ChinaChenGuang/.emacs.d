;;; init-yaml.el --- Modern YAML support (Tree-sitter First) -*- lexical-binding: t -*-

(if (and (fboundp 'treesit-ready-p)
         (treesit-ready-p 'yaml t))
    (use-package yaml-ts-mode
      :ensure nil
      :mode ("\\.ya?ml\\'")
      :config
      (setq yaml-ts-mode-indent-offset 2))
  (use-package yaml-mode
    :ensure nil
    :mode ("\\.ya?ml\\'")))

(provide 'init-yaml)
;;; init-yaml.el ends here
