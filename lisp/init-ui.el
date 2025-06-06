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
  ;; --- 设置字体 (Font Settings) ---
  (defun set-chinese-font-for-han ()
    "为中文字符集寻找并设置一个合适的字体。"
    (dolist (font '("Sarasa Mono SC" "WenQuanYi Micro Hei Mono" "Microsoft YaHei Mono" "PingFang SC" "sans-serif"))
      (when (find-font (font-spec :family font))
        (set-fontset-font t 'han (font-spec :family font))
        (return))))
  (set-chinese-font-for-han)

  ;; --- 加载主题 (Theme) ---
  ;; 使用 doom-one 主题，这是一个流行的暗色、低饱和度主题
  (use-package doom-themes
    :config
    (load-theme 'doom-one t)))

(provide 'init-ui)
;;; init-ui.el ends here
