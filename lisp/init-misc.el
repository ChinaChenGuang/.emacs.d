;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 其他插件配置 (Miscellaneous Packages)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle))

(use-package window-numbering
  :config
  (window-numbering-mode 1))

(provide 'init-misc)
;;; init-misc.el ends here
