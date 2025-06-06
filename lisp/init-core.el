;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Emacs 核心功能配置 (Core Emacs Functionality)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ----------------------------------------------------------------------
;; 性能与编码 (Performance & Encoding)
;; ----------------------------------------------------------------------
(setq gc-cons-threshold (* 100 1024 1024))

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)

;; 启用原生编译并确保缓存目录存在
(when (fboundp 'native-compile-async)
  (setq comp-deferred-compilation t
        comp-async-report-warnings-errors nil)
  ;; 定义并确保 eln-cache 目录存在
  (let ((eln-cache-dir (expand-file-name "eln-cache" user-emacs-directory)))
    (unless (file-directory-p eln-cache-dir)
      (make-directory eln-cache-dir t))
    ;; 开始异步原生编译
    (native-compile-async eln-cache-dir)))

;; ----------------------------------------------------------------------
;; 基础编辑功能 (Basic Editing Features)
;; ----------------------------------------------------------------------

;; 括号自动配对
(electric-pair-mode 1)

;; 代码折叠
(use-package origami
  :hook (prog-mode . origami-mode)
  :config
  (setq origami-hide-folded-region-instead-of-removing t))

(provide 'init-core)
;;; init-core.el ends here
