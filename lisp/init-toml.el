;;; init-toml.el --- TOML support (Tree-sitter first, pure-Elisp fallback) -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------
;; TOML 编辑支持
;; - 优先使用内置 toml-ts-mode（Tree-sitter AST 语法高亮与结构化缩进）
;; - 当当前 Emacs 未启用 tree-sitter / 加载不到 toml 语法库时，
;;   自动降级到 conf-toml-mode + 纯 Elisp 括号感知缩进器，保证任何环境可用
;; ----------------------------------------------------------------------

(require 'treesit nil t)

(defvar my/toml-tree-sitter-p
  (and (fboundp 'treesit-ready-p)
       (treesit-ready-p 'toml t))
  "Non-nil when the toml tree-sitter grammar can actually be loaded.")

;; ----------------------------------------------------------------------
;; 降级方案：纯 Elisp 结构化括号感知缩进器
;; ----------------------------------------------------------------------
(defun my/toml-indent-line ()
  "Simple, reliable, pure-Elisp bracket-depth indentation for TOML.
Automatically indents arrays/lists by 2 spaces and aligns closing brackets."
  (interactive)
  (let* ((bol (line-beginning-position))
         (closing (save-excursion
                    (goto-char bol)
                    (skip-chars-forward " \t")
                    (looking-at-p "[]}]")))
         (depth (car (syntax-ppss bol)))
         (indent (* (max 0 (if closing (1- depth) depth)) 2)))
    (save-excursion
      (goto-char bol)
      (skip-chars-forward " \t")
      (when (looking-at-p "^\\[+[^\\]\n]+\\]+")
        (setq indent 0)))
    (save-excursion
      (goto-char bol)
      (delete-horizontal-space)
      (indent-to indent))
    (when (< (point) (+ bol indent))
      (goto-char (+ bol indent)))))

(defun my/toml-classic-mode-setup ()
  "Configure reliable pure-Elisp indentation for conf-toml-mode buffers."
  (setq-local indent-line-function #'my/toml-indent-line)
  (setq-local tab-width 2)
  (setq-local standard-indent 2)
  (setq-local indent-tabs-mode nil)
  (electric-indent-local-mode 1)
  (setq-local electric-indent-chars (append '(?\] ?\}) electric-indent-chars))
  (local-set-key (kbd "TAB") #'indent-for-tab-command)
  (local-set-key (kbd "<tab>") #'indent-for-tab-command))

;; ----------------------------------------------------------------------
;; 模式关联
;; ----------------------------------------------------------------------
(if my/toml-tree-sitter-p
    (progn
      ;; toml-ts-mode 会通过 treesit-major-mode-remap-alist 自动接管 .toml/.kemurc，
      ;; 这里再显式绑定一次以覆盖手工改过 auto-mode-alist 的旧会话
      (add-to-list 'auto-mode-alist '("\\.kemurc\\'" . toml-ts-mode))
      (add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode))
      (with-eval-after-load 'toml-ts-mode
        (setq toml-ts-indent-offset 2)))
  (progn
    (add-to-list 'auto-mode-alist '("\\.kemurc\\'" . conf-toml-mode))
    (add-to-list 'auto-mode-alist '("\\.toml\\'" . conf-toml-mode))
    (add-hook 'conf-toml-mode-hook #'my/toml-classic-mode-setup)))

(provide 'init-toml)
;;; init-toml.el ends here
