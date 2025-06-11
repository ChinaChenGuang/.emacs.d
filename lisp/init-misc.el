;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 其他插件配置 (Miscellaneous Packages)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package neotree
  :bind ("<f8>" . neotree-toggle))

(use-package window-numbering
  :hook (after-init . window-numbering-mode))

(use-package avy
  :bind (("C-;" . avy-goto-char-timer)
         ("M-g g" . avy-goto-line)))

;; 使用 symbol-overlay 替换旧的 symbol-highlight
;; 它会在光标停留时自动高亮同名符号
(use-package symbol-overlay
  :ensure t
  :hook (prog-mode . symbol-overlay-mode)
  :config
  (define-key symbol-overlay-mode-map (kbd "M-n") #'symbol-overlay-jump-next)
  (define-key symbol-overlay-mode-map (kbd "M-p") #'symbol-overlay-jump-prev))

(provide 'init-misc)
;;; init-misc.el ends here
