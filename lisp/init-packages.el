;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 包管理配置 (Package Management)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; 添加包源 (使用上海交通大学 SJTUG 镜像以加速)
(setq package-archives '(("gnu" . "https://mirrors.sjtug.sjtu.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.sjtug.sjtu.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; 初始化包系统
(package-initialize)

;; 自动安装 use-package (如果它不存在)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; 启用 use-package 的 :ensure 关键字，使其可以自动安装包
(require 'use-package)
(setq use-package-always-ensure t)

(provide 'init-packages)
;;; init-packages.el ends here
