;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UI、字体和主题配置 (UI, Fonts, and Theme)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ----------------------------------------------------------------------
;; 界面元素 (UI Elements)
;; ----------------------------------------------------------------------

;; 全局开启行高亮
(global-hl-line-mode 1)

;; 显示行号
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)


;; ----------------------------------------------------------------------
;; 仅在图形界面 (GUI) 下生效的配置
;; ----------------------------------------------------------------------
(when (display-graphic-p)
  ;; --- 禁用菜单栏 ---
  (menu-bar-mode -1)

  ;; --- 设置字体 (Font Settings) ---
  (defun set-chinese-font-for-han ()
    "为中文字符集寻找并设置一个合适的字体，对 Windows 和其他系统分别处理。"
    (catch 'font-found
      ;; 根据操作系统类型，选择不同的字体列表进行尝试
      (let ((fonts (if (eq system-type 'windows-nt)
                       ;; Windows 字体列表
                       '("Sarasa Mono SC" "Microsoft YaHei Mono" "SimSun" "sans-serif")
                     ;; Linux/macOS 字体列表
                     '("Sarasa Mono SC" "WenQuanYi Micro Hei Mono" "PingFang SC" "sans-serif"))))
        (dolist (font fonts)
          (when (find-font (font-spec :family font))
            (set-fontset-font t 'han (font-spec :family font))
            (throw 'font-found t))))))
  (set-chinese-font-for-han)

  ;; --- 加载主题 (Theme) ---
  ;; 确保 doom-themes 插件被 use-package 管理
  (use-package doom-themes)

  ;; 使用 with-eval-after-load 来确保在主题加载后进行自定义
  (with-eval-after-load 'doom-themes
    ;; 首先加载主题
    (load-theme 'doom-one t)
    ;; 然后修改行高亮颜色为低饱和度的深灰色
    (set-face-background 'hl-line "#353a42")))

(provide 'init-ui)
;;; init-ui.el ends here
