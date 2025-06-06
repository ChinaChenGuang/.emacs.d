;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 包管理配置 (Package Management)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; 设置一个常见的 User-Agent，避免被某些服务器拒绝
(setq url-http-user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0")
;; 禁用 GPG 签名检查，以解决密钥过期问题
(setq package-check-signatures nil)

;; 1. 设置包源 (使用官方源，协议为 http)
;; 这是为了解决持续出现的网络连接问题，直接从源头获取列表。
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")
			 ("nongnu" . "http://elpa.nongnu.org/nongnu/")))

;; 2. 定义所有需要安装的包
(defvar my-packages
  '(;; UI & 主题
    doom-themes

    ;; 核心功能
    origami

    ;; 开发环境 & 补全
    company
    vertico
    marginalia
    orderless
    python-mode
    verilog-mode

    ;; 其他工具
    neotree
    window-numbering
    avy)
  "A list of packages to ensure are installed.")

;; 3. 核心安装函数
(defun my-packages-install ()
  "Force refresh package contents and install all packages in `my-packages`."
  (interactive)
  (message "Forcing package refresh and installing packages...")
  ;; 强制清空旧的包列表数据，确保下载最新的列表
  (setq package-archive-contents nil)
  (package-refresh-contents)
  (dolist (pkg my-packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; 4. 初始化包系统
(package-initialize)

;; 5. 首次启动时自动安装所有包
;; (通过检查 elpa 目录是否存在来判断是否为首次启动)
(unless (file-directory-p package-user-dir)
  (make-directory package-user-dir t)
  (my-packages-install))

;; 6. 配置 use-package
(require 'use-package)
;; 禁用 use-package 的自动安装功能，因为我们已经手动处理
(setq use-package-always-ensure nil)

(provide 'init-packages)
;;; init-packages.el ends here
