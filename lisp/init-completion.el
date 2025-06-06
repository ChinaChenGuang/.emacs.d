;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 补全框架配置 (Completion Framework)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Vertico: 一个高性能、极简的迷你缓冲区补全界面
(use-package vertico
  :init
  (vertico-mode))

;; Marginalia: 为迷你缓冲区中的补全项提供丰富的注解
;; 例如，在切换缓冲区时，它会显示文件的路径
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

;; Orderless: 提供更强大的模糊匹配和多词匹配功能
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))


(provide 'init-completion)
;;; init-completion.el ends here
