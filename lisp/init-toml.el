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
;; 结构化折叠引擎 (支持 [section] 表头与多行数组/缩进块)
;; ----------------------------------------------------------------------
(defun my/toml--get-section-bounds ()
  "获取当前光标所在或所属的 TOML [section] 范围 (BEG . END)。"
  (save-excursion
    (beginning-of-line)
    (let (beg end)
      (if (looking-at-p "^[ \t]*\\[")
          (setq beg (line-end-position))
        (when (re-search-backward "^[ \t]*\\[" nil t)
          (setq beg (line-end-position))))
      (when beg
        (forward-line 1)
        (if (re-search-forward "^[ \t]*\\[" nil t)
            (progn
              (beginning-of-line)
              (skip-chars-backward " \t\n")
              (setq end (point)))
          (setq end (point-max)))
        (when (> end beg)
          (cons beg end))))))

(defun my/toml-fold-toggle ()
  "智能折叠/展开当前 TOML 元素或 [section] 节。
支持 C-c RET 快捷键：
- 当前已有折叠：展开当前区域；
- 当前行存在缩进子块（如多行数组）：优先按缩进折叠；
- 当前行处于 [section] 表头或其内部：直接折叠整个 section 内容。"
  (interactive)
  (require 'yafolding nil t)
  (let ((ovs (if (fboundp 'yafolding-get-overlays)
                 (yafolding-get-overlays (line-beginning-position)
                                        (1+ (line-end-position)))
               nil)))
    (if ovs
        (when (fboundp 'yafolding-show-element)
          (yafolding-show-element))
      ;; 优先尝试折叠有缩进的代码块 (如数组或表格)
      (let ((region (and (fboundp 'yafolding-get-element-region)
                         (yafolding-get-element-region))))
        (if (and region (> (cadr region) (car region)))
            (apply #'yafolding-hide-region region)
          ;; 否则折叠整个 TOML [section]
          (let ((bounds (my/toml--get-section-bounds)))
            (if bounds
                (if (fboundp 'yafolding-hide-region)
                    (yafolding-hide-region (car bounds) (cdr bounds))
                  (outline-toggle-children))
              (message "未在当前光标处发现可折叠的 [section] 或代码块"))))))))

(defun my/toml-fold-toggle-all ()
  "一键折叠/展开当前 TOML 文件的全部 [section] 节。
支持 C-c Y 快捷键：
- 如果已有折叠：全部展开；
- 如果未折叠：将所有 [section] 一键全部收起，仅露出节标题。"
  (interactive)
  (require 'yafolding nil t)
  (let ((has-fold (and (fboundp 'yafolding-get-overlays)
                       (yafolding-get-overlays (point-min) (point-max)))))
    (if has-fold
        (when (fboundp 'yafolding-show-all)
          (yafolding-show-all))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "^[ \t]*\\[" nil t)
          (let ((bounds (my/toml--get-section-bounds)))
            (when (and bounds (fboundp 'yafolding-hide-region))
              (yafolding-hide-region (car bounds) (cdr bounds)))))
        (message "已将所有 TOML [section] 折叠收起 (按 C-c Y 或 C-c RET 可展开)")))))

(defun my/toml-folding-setup ()
  "在当前 TOML 缓冲区配置折叠按键与 Outline 原生联动。"
  ;; 1. 绑定折叠快捷键 (保持与全局 C-c RET 和 C-c Y 完全一致)
  (local-set-key (kbd "C-c RET") #'my/toml-fold-toggle)
  (local-set-key (kbd "C-c <return>") #'my/toml-fold-toggle)
  (local-set-key (kbd "C-c Y") #'my/toml-fold-toggle-all)
  ;; 2. 原生 outline-minor-mode 补充 (在表头行按 TAB 也能像 Org-mode 一样直接折叠/展开)
  (setq-local outline-regexp "^[ \t]*\\[+")
  (when (fboundp 'outline-minor-mode-cycle)
    (setq-local outline-minor-mode-cycle t))
  (outline-minor-mode 1))

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
        (setq toml-ts-indent-offset 2))
      (add-hook 'toml-ts-mode-hook #'my/toml-folding-setup))
  (progn
    (add-to-list 'auto-mode-alist '("\\.kemurc\\'" . conf-toml-mode))
    (add-to-list 'auto-mode-alist '("\\.toml\\'" . conf-toml-mode))
    (add-hook 'conf-toml-mode-hook #'my/toml-classic-mode-setup)
    (add-hook 'conf-toml-mode-hook #'my/toml-folding-setup)))

(provide 'init-toml)
;;; init-toml.el ends here
