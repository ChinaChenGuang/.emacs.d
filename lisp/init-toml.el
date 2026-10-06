;;; init-toml.el --- Pure-Elisp robust TOML support -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------
;; 纯 Elisp 结构化括号感知缩进器 (零 Tree-sitter 依赖，完美兼容离线与旧版环境)
;; ----------------------------------------------------------------------
(defun my/toml-indent-line ()
  "Simple, reliable, pure-Elisp bracket-depth indentation for TOML.
Automatically indents arrays/lists by 2 spaces and aligns closing brackets."
  (interactive)
  (let* ((bol (line-beginning-position))
         ;; 当前行是否以闭合括号 ] 或 } 开头
         (closing (save-excursion
                    (goto-char bol)
                    (skip-chars-forward " \t")
                    (looking-at-p "[]}]")))
         ;; syntax-ppss 内置解析括号嵌套深度
         (depth (car (syntax-ppss bol)))
         (indent (* (max 0 (if closing (1- depth) depth)) 2)))
    ;; 表头如 [section] 或 [[table-array]] 始终顶格
    (save-excursion
      (goto-char bol)
      (skip-chars-forward " \t")
      (when (looking-at-p "^\\[+[^\\]\n]+\\]+")
        (setq indent 0)))
    ;; 执行缩进
    (save-excursion
      (goto-char bol)
      (delete-horizontal-space)
      (indent-to indent))
    ;; 光标若在缩进之前则移至缩进之后
    (when (< (point) (+ bol indent))
      (goto-char (+ bol indent)))))

(defun my/toml-mode-setup ()
  "Configure reliable pure-Elisp indentation for TOML buffers."
  (setq-local indent-line-function #'my/toml-indent-line)
  (setq-local tab-width 2)
  (setq-local standard-indent 2)
  (setq-local indent-tabs-mode nil)
  ;; 开启回车自动缩进，并在输入 ] 或 } 时自动退格对齐
  (electric-indent-local-mode 1)
  (setq-local electric-indent-chars (append '(?\] ?\}) electric-indent-chars))
  ;; TAB 键绑定标准缩进
  (local-set-key (kbd "TAB") #'indent-for-tab-command)
  (local-set-key (kbd "<tab>") #'indent-for-tab-command))

;; 全局关联 TOML 与 .kemurc 到 conf-toml-mode，彻底不依赖外部 tree-sitter
(add-to-list 'auto-mode-alist '("\\.kemurc\\'" . conf-toml-mode))
(add-to-list 'auto-mode-alist '("\\.toml\\'" . conf-toml-mode))
(add-hook 'conf-toml-mode-hook #'my/toml-mode-setup)

(provide 'init-toml)
;;; init-toml.el ends here
