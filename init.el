;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 主配置文件 (Main Configuration File) - init.el
;; 这个文件是 Emacs 启动的入口，它的作用是加载其他配置文件。
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 将 'lisp' 目录添加到加载路径中，以便 Emacs 能找到我们的模块化配置
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; 依次加载各个配置模块
(require 'init-packages)
(require 'init-ui)
(require 'init-core)
(require 'init-completion) ; <-- 新增：加载补全框架配置
(require 'init-dev)
(require 'init-misc)
(require 'init-dashboard)
;; 加载 Emacs 通过 `M-x customize` 保存的自定义设置
;; 将其放在最后，以确保它能覆盖其他设置
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
