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

;; Avy 配置，用于在当前可视区域内快速跳转
(use-package avy
  :bind (("C-;" . avy-goto-char-timer) ; 使用 C-; 触发字符跳转
	 ("M-g g" . avy-goto-line)))    ; 使用 M-g g 跳转到任意行

(provide 'init-misc)
;;; init-misc.el ends here
