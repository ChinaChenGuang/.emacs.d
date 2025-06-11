;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 补全框架配置 (Completion Framework)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. 声明需要 ivy 和 counsel 插件。
;;    这会确保它们被 Emacs 识别，但我们不在这里做任何配置。
(use-package ivy)
(use-package counsel)

;; 2. 使用 with-eval-after-load 来进行配置。
;;    这会保证在 'ivy' 包完全加载到内存之后，才执行里面的代码。
;;    这是解决 "Cannot load" 问题的最可靠方法。
(with-eval-after-load 'ivy
  (message "Ivy has been loaded. Configuring...")
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")

  ;; 因为 counsel 依赖 ivy，所以我们将它的配置也放在这里。
  (require 'counsel)
  (global-set-key (kbd "M-x") #'counsel-M-x)
  (global-set-key (kbd "C-x C-f") #'counsel-find-file)
  (global-set-key (kbd "C-x b") #'counsel-switch-buffer))

(provide 'init-completion)
;;; init-completion.el ends here
