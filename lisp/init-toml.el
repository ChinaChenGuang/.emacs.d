;;; init-toml.el --- Basic TOML support -*- lexical-binding: t -*-

(add-to-list 'auto-mode-alist '("\\.kemurc\\'" . conf-toml-mode))
(add-to-list 'auto-mode-alist '("\\.toml\\'" . conf-toml-mode))

(provide 'init-toml)
;;; init-yaml.el ends here
