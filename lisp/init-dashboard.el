;; =============================================================================
;; Emacs Dashboard Configuration
;;
;; 使用方法:
;; 1. 将此代码添加到您的 Emacs 配置文件中 (~/.emacs.d/init.el)。
;; 2. 您可以直接编辑 `dashboard-startup-banner` 中的字符图，或者将其指向一个包含您自己的字符图的文本文件。
;; 3. 重启 Emacs 即可看到效果。
;;
;; 注意:
;; - 此配置使用了 `use-package` 来管理插件，这是现代 Emacs 配置的推荐方式。
;; - 如果您没有安装 `use-package`，Emacs 会在启动时自动为您安装。
;; =============================================================================

;; --- 确保 package.el (Emacs的包管理器) 已被初始化 ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (package-initialize)

;; --- 自动安装和配置 use-package ---
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-after-load 'use-package
  '(require 'use-package-ensure))

;; --- 配置 dashboard 插件 ---
(use-package dashboard
  :ensure t  ; 确保 dashboard 插件已安装
  :config
  (progn
    ;; 设置 dashboard 为 Emacs 的启动页面
    (dashboard-setup-startup-hook)

    ;; ** (关键修改) 设置您的字符图 (ASCII Art) **
    ;; 您可以直接在这里编辑下面的字符串来创建您自己的字符图。
    ;; 注意：为了让 Emacs 正确解析，每一行末尾的 `\` 和所有引号前的 `\` 都是必需的。
    (setq dashboard-startup-banner
          "
      ███████╗███╗   ███╗ █████╗  ██████╗███████╗
      ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝
      █████╗  ██╔████╔██║███████║██║     ███████╗
      ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║
      ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║
      ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝
      ")

    ;; ** (备选方案) 从文件中加载字符图 **
    ;; 如果您的字符图很复杂，更好的方式是将其保存在一个文本文件中，然后加载它。
    ;; 只需取消下面这行的注释，并把路径修改为您自己的文件路径即可。
    ;; (setq dashboard-startup-banner '("/path/to/your/ascii-art.txt"))


    ;; 设置首页上显示的项目列表
    (setq dashboard-items '((recents . 5)   ; 显示 5 个最近访问的文件
                            (projects . 5)  ; 显示 5 个最近的项目
                            (bookmarks . 5) ; 显示 5 个书签
                            (agenda . 5)))  ; 显示 5 条日程 (如果使用 org-mode)

    ;; (可选) 让 dashboard 居中显示
    (setq dashboard-center-content t)

    ;; (可选) 在 dashboard 页面上，按下 'q' 键可以退出 Emacs
    (define-key dashboard-mode-map (kbd "q") 'save-buffers-kill-terminal)
    )
  )

;; --- (可选) 为了更好地管理项目，推荐安装 projectile ---
;; dashboard 可以和 projectile 插件无缝集成，以更好地显示“最近的项目”
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

(provide 'init-dashboard)
