;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 包管理配置 (Package Management)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; -- 基础网络和签名设置 --
(setq url-http-user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0")
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; (setq package-check-signatures nil)

;; 1. 设置包源 (使用清华 TUNA 镜像)
;; (setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                          ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
;;                          ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa"  . "https://melpa.org/packages/")))
;; 2. 初始化包系统并刷新包列表
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; 3. 自动安装并配置 use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
;; 设置 use-package 默认自动安装所有未安装的包
(setq use-package-always-ensure t)

(provide 'init-packages)
;;; init-packages.el ends here
