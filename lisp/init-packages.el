;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 包管理配置 (Package Management)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; 设置一个常见的 User-Agent，避免被某些服务器拒绝
(setq url-http-user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0")

;; 解决 GPG 密钥过期问题
(setq package-check-signatures nil)

;; 添加包源 (使用国内镜像以加速)
;;
;; 注意：已将协议从 https 更改为 http，以解决持续出现的 443 连接错误。
;; 这通常是由于本地网络环境（如防火墙）限制所致。
;;
;; 当前使用：腾讯云镜像
(setq package-archives '(("gnu" . "http://mirrors.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.tencent.com/elpa/melpa/")
                         ("nongnu" . "http://elpa.nongnu.org/nongnu/"))) ;; nongnu 不支持 http，保留原样

;; --------------------- 备选镜像源 (同样使用 http) ---------------------
;; --- 中国科学技术大学 (USTC) ---
;; (setq package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/")
;;                          ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/")
;;                          ("nongnu" . "http://elpa.nongnu.org/nongnu/")))
;;
;; --- 清华大学 (TUNA) ---
;; (setq package-archives '(("gnu" . "http://elpa.tuna.tsinghua.edu.cn/gnu/")
;;                          ("melpa" . "http://elpa.tuna.tsinghua.edu.cn/elpa/melpa/")
;;                          ("nongnu" . "http://elpa.nongnu.org/nongnu/")))
;; ----------------------------------------------------


;; 初始化包系统
(package-initialize)

;; 检查包列表是否已加载，如果没有，则刷新它
;; 这是解决 "Package is unavailable" 错误的关键
(unless package-archive-contents
  (package-refresh-contents))

;; 自动安装 use-package (如果它不存在)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; 启用 use-package 的 :ensure 关键字，使其可以自动安装包
(require 'use-package)
(setq use-package-always-ensure t)

(provide 'init-packages)
;;; init-packages.el ends here
