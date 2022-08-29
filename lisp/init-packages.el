(use-package restart-emacs)
(use-package verilog-mode)
(use-package benchmark-init
  :init (benchmark-init/activate)
  :hook (after-init . benchmark-init/deactivate))
;;(use-package treemacs)
;;donwload auto-complete and dependence
(use-package auto-complete)
(use-package pos-tip)
;;(use-package neotree
;;  :ensure t
;;  :bind-keymap ([F8] . neotree-toggle))
(use-package fuzzy)
(use-package avy
  :ensure t
  :bind (("C-:" . avy-goto-char))
  )
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :hook(after-init . ivy-mode))
(provide 'init-packages)
