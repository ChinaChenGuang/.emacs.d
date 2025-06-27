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

;; 启用原生编译，但在 Windows 系统上禁用，因为它需要额外配置 libgccjit。
(when (and (fboundp 'native-compile-async)
           (not (eq system-type 'windows-nt)))
  (message "Native compilation is enabled.")
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
  (setq origami-hide-folded-region-instead-of-removing t)
  ;; 在 origami-mode 的 keymap 中定义快捷键，确保函数已加载
  (define-key origami-mode-map (kbd "C-c o t") #'origami-toggle-node) ; t for toggle
  (define-key origami-mode-map (kbd "C-c o f") #'origami-fold-all)    ; f for fold
  (define-key origami-mode-map (kbd "C-c o u") #'origami-unfold-all))  ; u for unfold

(provide 'init-core)
;;; init-core.el ends here
