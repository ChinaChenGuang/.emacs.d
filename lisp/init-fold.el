;;; init-fold.el --- Modern AST-based folding with Tree-sitter -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; 基于 Emacs 29/30/31 原生 Tree-sitter AST 的现代高精度代码折叠系统：
;; - 彻底淘汰基于空格缩进猜测的陈旧 yafolding 方案；
;; - 直接依据语法树节点（函数、模块、类、always 块、table、代码块等）精准折叠；
;; - 绝不受代码空行、行内换行或 0 缩进（如 TOML [section]）的干扰；
;; - 带有温和的折叠行数统计指示器，如 " ... [15 lines] "；
;; - isearch 搜索命中折叠区域时自动展开；
;; - 非 Tree-sitter 环境优雅回退至 Emacs 原生内置的 hideshow (hs-minor-mode)
;;   以及针对于配置文件的 [section] 结构化表头折叠。
;;
;; 快捷键映射（全局统一）：
;;   C-c RET / C-c <return> : 智能折叠 / 展开当前代码块或语法节点 (DWIM)
;;   C-c Y                  : 一键折叠 / 展开全文件所有顶级定义
;;

(require 'treesit nil t)
(require 'seq)
(require 'cl-lib)
(require 'hideshow)

(defgroup my/fold nil
  "Modern Tree-sitter code folding."
  :group 'programming)

;; ----------------------------------------------------------------------
;; 1. 各语言支持的 AST 语法节点映射表
;; ----------------------------------------------------------------------
(defvar my/ts-fold-node-types-alist
  '((verilog
     . ("module_declaration" "interface_declaration" "package_declaration"
        "class_declaration" "task_declaration" "function_declaration"
        "always_construct" "initial_construct" "final_construct"
        "generate_region" "seq_block" "case_statement" "specify_block"))
    (systemverilog
     . ("module_declaration" "interface_declaration" "package_declaration"
        "class_declaration" "task_declaration" "function_declaration"
        "always_construct" "initial_construct" "final_construct"
        "generate_region" "seq_block" "case_statement" "specify_block"))
    (c
     . ("function_definition" "struct_specifier" "enum_specifier"
        "compound_statement" "preproc_if" "preproc_ifdef"))
    (cpp
     . ("function_definition" "class_specifier" "struct_specifier"
        "enum_specifier" "compound_statement" "namespace_definition"
        "preproc_if" "preproc_ifdef"))
    (rust
     . ("function_item" "impl_item" "struct_item" "enum_item"
        "trait_item" "block" "match_expression" "mod_item" "macro_definition"))
    (toml
     . ("table" "table_array_element"))
    (yaml
     . ("block_mapping_pair" "block_sequence" "document"))
    (python
     . ("function_definition" "class_definition" "if_statement"
        "while_statement" "for_statement" "try_statement" "with_statement"
        "dictionary" "list"))
    (bash
     . ("function_definition" "compound_statement" "c_style_for_statement"
        "for_statement" "while_statement" "if_statement" "case_statement"))
    (json
     . ("object" "array")))
  "Alist mapping treesit language symbols to lists of foldable AST node type names.")

;; ----------------------------------------------------------------------
;; 2. 核心算法：节点判断与边界计算
;; ----------------------------------------------------------------------
(defun my/ts-fold--node-foldable-p (node lang)
  "Return non-nil if NODE of language LANG spans multiple lines and is foldable."
  (when node
    (let ((type (treesit-node-type node))
          (types (cdr (assq lang my/ts-fold-node-types-alist))))
      (and (> (line-number-at-pos (treesit-node-end node))
              (line-number-at-pos (treesit-node-start node)))
           (if types
               (member type types)
             ;; 通用启发式 AST 类型识别
             (string-match-p "\\(block\\|statement\\|declaration\\|definition\\|table\\|array\\|object\\)" type))))))

(defun my/ts-fold--find-target-node (node lang)
  "Find the closest foldable ancestor or NODE itself for language LANG."
  (let ((curr node))
    (while (and curr (not (my/ts-fold--node-foldable-p curr lang)))
      (setq curr (treesit-node-parent curr)))
    curr))

(defun my/ts-fold--get-range (node)
  "Calculate (BEG . END) for folding NODE.
Keeps the header line visible and folds through to the block's end."
  (save-excursion
    (goto-char (treesit-node-start node))
    (let* ((beg (line-end-position))
           (node-end (treesit-node-end node)))
      (goto-char node-end)
      (when (bolp) (forward-line -1))
      (let ((end (line-end-position)))
        (when (> end beg)
          (cons beg end))))))

(defun my/ts-fold--collect-foldable-nodes (root lang)
  "Recursively collect all foldable nodes under ROOT for language LANG."
  (let (result
        (stack (list root)))
    (while stack
      (let ((curr (pop stack)))
        (when (my/ts-fold--node-foldable-p curr lang)
          (push curr result))
        (dolist (child (nreverse (treesit-node-children curr t)))
          (push child stack))))
    (nreverse result)))

;; ----------------------------------------------------------------------
;; 2.1 传统模式兜底：Conf / TOML / INI 文件的 [section] 表格识别
;; ----------------------------------------------------------------------
(defconst my/conf-fold-section-header-regexp
  "^[ \t]*\\[+[^]\n]+\\]+"
  "Regular expression matching section/table headers in INI and TOML files.")

(defun my/conf-fold--get-section-bounds ()
  "Get (BEG . END) for folding the current [section] in conf/toml mode.
Keeps the header line visible and folds up to the start of the next section."
  (save-excursion
    (let (beg end)
      (beginning-of-line)
      (if (looking-at-p my/conf-fold-section-header-regexp)
          (setq beg (line-end-position))
        (when (re-search-backward my/conf-fold-section-header-regexp nil t)
          (setq beg (line-end-position))))
      (when beg
        (forward-line 1)
        (if (re-search-forward my/conf-fold-section-header-regexp nil t)
            (progn
              (beginning-of-line)
              (forward-line -1)
              (setq end (line-end-position)))
          (setq end (point-max)))
        (when (> end beg)
          (cons beg end))))))

;; ----------------------------------------------------------------------
;; 3. Overlay 管理与视觉呈现
;; ----------------------------------------------------------------------
(defun my/ts-fold--open-overlay (ov)
  "Handler for isearch to automatically reveal hidden content."
  (delete-overlay ov))

(defun my/ts-fold--make-overlay (beg end)
  "Create a visual folding overlay between BEG and END without duplicates."
  (unless (seq-some (lambda (ov)
                      (and (overlay-get ov 'my-ts-fold)
                           (= (overlay-start ov) beg)
                           (= (overlay-end ov) end)))
                    (overlays-in beg end))
    (let* ((lines (count-lines beg end))
           (ov (make-overlay beg end)))
      (overlay-put ov 'my-ts-fold t)
      (overlay-put ov 'invisible 'my-ts-fold)
      (overlay-put ov 'isearch-open-invisible #'my/ts-fold--open-overlay)
      (overlay-put ov 'display
                   (propertize (format " ... [%d lines] " lines)
                               'face '(:inherit shadow :weight bold)))
      ov)))

(defun my/ts-fold--overlays-at-line ()
  "Return folding overlays overlapping current line."
  (let ((beg (line-beginning-position))
        (end (min (point-max) (1+ (line-end-position)))))
    (seq-filter (lambda (ov) (overlay-get ov 'my-ts-fold))
                (overlays-in beg end))))

(defun my/ts-fold--all-overlays ()
  "Return all active folding overlays in current buffer."
  (seq-filter (lambda (ov) (overlay-get ov 'my-ts-fold))
              (overlays-in (point-min) (point-max))))

;; ----------------------------------------------------------------------
;; 4. 交互命令：DWIM 智能单块与全局折叠
;; ----------------------------------------------------------------------
(defun my/fold-toggle ()
  "Smart toggle folding for current AST node or fallback block.
Bound to C-c RET / C-c <return>."
  (interactive)
  (let ((ovs (my/ts-fold--overlays-at-line)))
    (if ovs
        ;; A. 如果当前行已有折叠：展开
        (mapc #'delete-overlay ovs)
      ;; B. 处于 Tree-sitter 模式：AST 精确折叠
      (if (and (fboundp 'treesit-parser-list)
               (treesit-parser-list))
          (let* ((node (treesit-node-at (point)))
                 (lang (treesit-language-at (point)))
                 (target (my/ts-fold--find-target-node node lang)))
            (if target
                (let ((range (my/ts-fold--get-range target)))
                  (if range
                      (progn
                        (my/ts-fold--make-overlay (car range) (cdr range))
                        ;; 若光标落在被折叠的区域内，则将光标拉回到表头行末
                        (when (> (point) (car range))
                          (goto-char (car range))))
                    (message "该语法节点只有单行，无需折叠")))
              (message "未在光标处找到可折叠的语法块")))
        ;; C. 传统模式兜底
        (cond
         ;; C1. conf-mode / conf-toml-mode 等配置模式：依据 [section] 表头精准折叠
         ((derived-mode-p 'conf-mode)
          (let ((range (my/conf-fold--get-section-bounds)))
            (if range
                (progn
                  (my/ts-fold--make-overlay (car range) (cdr range))
                  (when (> (point) (car range))
                    (goto-char (car range))))
              (message "未在当前光标处找到可折叠的 [section] 表格"))))
         ;; C2. 传统编程模式：hideshow 原生兜底
         ((bound-and-true-p hs-minor-mode)
          (hs-toggle-hiding))
         (t
          (message "当前模式未启用代码折叠支持")))))))

(defun my/fold-toggle-all ()
  "Toggle fold for all definitions in buffer.
Bound to C-c Y."
  (interactive)
  (let ((all-ovs (my/ts-fold--all-overlays)))
    (if all-ovs
        ;; 已有折叠：全部展开
        (progn
          (mapc #'delete-overlay all-ovs)
          (message "已展开全文件代码"))
      ;; 未折叠：全篇折叠
      (if (and (fboundp 'treesit-parser-list)
               (treesit-parser-list))
          (let* ((root (treesit-parser-root-node (car (treesit-parser-list))))
                 (lang (treesit-language-at (point-min)))
                 (nodes (my/ts-fold--collect-foldable-nodes root lang))
                 (count 0))
            (dolist (node nodes)
              (let ((range (my/ts-fold--get-range node)))
                (when (and range (my/ts-fold--make-overlay (car range) (cdr range)))
                  (cl-incf count))))
            (message "已折叠 %d 个代码块 (按 C-c Y 或 C-c RET 可展开)" count))
        (cond
         ;; conf-mode / conf-toml-mode 全局一键折叠所有 [section]
         ((derived-mode-p 'conf-mode)
          (let ((count 0))
            (save-excursion
              (goto-char (point-min))
              (while (re-search-forward my/conf-fold-section-header-regexp nil t)
                (let ((range (my/conf-fold--get-section-bounds)))
                  (when (and range (my/ts-fold--make-overlay (car range) (cdr range)))
                    (cl-incf count)))))
            (message "已折叠 %d 个 [section] 表格 (按 C-c Y 或 C-c RET 可展开)" count)))
         ((bound-and-true-p hs-minor-mode)
          (progn
            (if (hs-already-hidden-p)
                (hs-show-all)
              (hs-hide-all))
            (message "已切换 hideshow 全局折叠状态")))
         (t
          (message "当前模式未启用全局折叠支持")))))))

;; ----------------------------------------------------------------------
;; 5. Minor Mode 与按键挂载
;; ----------------------------------------------------------------------
(defvar my-fold-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c RET") #'my/fold-toggle)
    (define-key map (kbd "C-c <return>") #'my/fold-toggle)
    (define-key map (kbd "C-c Y") #'my/fold-toggle-all)
    map)
  "Keymap for `my-fold-mode'.")

;;;###autoload
(define-minor-mode my-fold-mode
  "基于 Tree-sitter AST 的现代化轻量代码折叠模式。"
  :lighter " ▾"
  :keymap my-fold-mode-map
  (if my-fold-mode
      (progn
        (add-to-invisibility-spec 'my-ts-fold)
        ;; 非 Tree-sitter 模式且非 conf 模式时自动启用 hideshow 兜底
        (unless (or (and (fboundp 'treesit-parser-list) (treesit-parser-list))
                    (derived-mode-p 'conf-mode))
          (hs-minor-mode 1)))
    (remove-from-invisibility-spec 'my-ts-fold)
    (mapc #'delete-overlay (my/ts-fold--all-overlays))))

;; 默认挂载到所有编程与配置模式
(dolist (hook '(prog-mode-hook conf-mode-hook))
  (add-hook hook #'my-fold-mode))

(provide 'init-fold)
;;; init-fold.el ends here
