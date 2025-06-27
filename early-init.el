;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 早期初始化文件 (Early Init File) - early-init.el
;; 这些设置在包系统初始化之前生效，主要用于优化启动性能和初始 UI。
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 在启动时禁用文件处理器的提示，加快启动速度
(setq-default inhibit-splash-screen t)
(setq-default inhibit-startup-message t)
(setq-default initial-scratch-message nil)
(setq package-check-signatures nil)

;; 调整垃圾回收阈值，在启动时减少卡顿
;; 启动后 Emacs 会根据使用情况自动调整
(setq gc-cons-threshold (* 128 1024 1024))
(setq read-process-output-max (* 1024 1024))

;; 仅在图形界面模式下禁用 UI 元素，避免在终端中产生不必要的设置
(when (display-graphic-p)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

;;; early-init.el ends here
