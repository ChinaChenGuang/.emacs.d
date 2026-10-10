;;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Verilog & SystemVerilog Configuration
;;
;; - 优先使用 verilog-ts-mode（Tree-sitter AST：语法高亮 + 结构化缩进）
;; - tree-sitter 语法库不可用时，自动降级到内置经典 verilog-mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'treesit nil t)

(defvar my/verilog-tree-sitter-p
  (and (fboundp 'treesit-ready-p)
       (treesit-ready-p 'systemverilog t))
  "Non-nil when the systemverilog tree-sitter grammar can be loaded.")

;; ----------------------------------------------------------------------
;; 通用风格设置（两种模式共用）
;; ----------------------------------------------------------------------
(defun my/verilog-style-setup ()
  "Custom style for Verilog and SystemVerilog."
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local backward-delete-char-untabify-method 'hungry)
  (setq-local verilog-auto-newline nil)
  (setq-local verilog-auto-lineup nil))

(defun my/verilog-classic-setup ()
  "Hook for classic built-in `verilog-mode'."
  (my/verilog-style-setup)
  ;; 缩进 4 空格，宏指令跟随代码块
  (setq-local verilog-indent-level 4)
  (setq-local verilog-indent-level-module 4)
  (setq-local verilog-indent-level-declaration 4)
  (setq-local verilog-indent-level-behavioral 4)
  (setq-local verilog-indent-level-directive 1)
  (setq-local verilog-case-indent 4)
  (setq-local verilog-cexp-indent 4)
  (setq-local verilog-indent-lists 4)
  ;; 经典模式下 electric-indent 表现糟糕，保持关闭
  (electric-indent-local-mode -1))

(defun my/verilog-ts-setup ()
  "Hook for `verilog-ts-mode'."
  (my/verilog-style-setup)
  (setq-local verilog-ts-indent-level 4)
  (electric-indent-local-mode 1))

;; ----------------------------------------------------------------------
;; 模式关联：优先 verilog-ts-mode，降级 verilog-mode
;; ----------------------------------------------------------------------
(if my/verilog-tree-sitter-p
    (progn
      (use-package verilog-ts-mode
        :ensure nil
        :mode ("\\.v\\'" "\\.sv\\'" "\\.svh\\'")
        :hook (verilog-ts-mode . my/verilog-ts-setup))
      ;; 兜底：经典 verilog-mode 也配置好，防止个别文件被手工切回
      (add-hook 'verilog-mode-hook #'my/verilog-classic-setup))
  (progn
    (use-package verilog-mode
      :ensure nil
      :mode ("\\.v\\'" "\\.sv\\'" "\\.svh\\'")
      :hook (verilog-mode . my/verilog-classic-setup)
      :config
      (setq verilog-indent-level 4)
      (setq verilog-indent-level-module 4)
      (setq verilog-indent-level-declaration 4)
      (setq verilog-indent-level-behavioral 4)
      (setq verilog-indent-level-directive 1)
      (setq verilog-case-indent 4)
      (setq verilog-auto-newline nil)
      (setq verilog-auto-lineup nil))))

;; ----------------------------------------------------------------------
;; Robust Verible Formatting & Project Indexing
;; ----------------------------------------------------------------------
(defun my/verilog-format ()
  "Format current buffer or region using Verible.
Provides transparent error reporting if syntax errors prevent formatting."
  (interactive)
  (if (use-region-p)
      (let ((start (region-beginning))
            (end (region-end)))
        (if (executable-find "verible-verilog-format")
            (let ((err-buf "*verible-error*"))
              (with-current-buffer (get-buffer-create err-buf) (erase-buffer))
              (if (eq 0 (call-process-region start end "verible-verilog-format" t t nil "-" "--column_limit=100" "--indentation_spaces=4"))
                  (progn
                    (when (get-buffer err-buf) (kill-buffer err-buf))
                    (message "✅ 选区格式化成功 (Verible)!"))
                (display-buffer err-buf)
                (message "❌ 格式化终止：选区内存在语法错误，请查看 %s" err-buf)))
          (indent-region start end)
          (message "✅ 选区已缩进 (传统模式)")))
    ;; 全文件格式化
    (if (executable-find "verible-verilog-format")
        (let ((err-buf "*verible-error*")
              (line (line-number-at-pos))
              (col (current-column)))
          (with-current-buffer (get-buffer-create err-buf) (erase-buffer))
          (if (eq 0 (call-process-region (point-min) (point-max) "verible-verilog-format" nil (list t err-buf) nil "-" "--column_limit=100" "--indentation_spaces=4"))
              (progn
                (erase-buffer)
                (insert-buffer-substring err-buf)
                (when (get-buffer err-buf) (kill-buffer err-buf))
                (goto-char (point-min))
                (forward-line (1- line))
                (move-to-column col)
                (message "✅ 代码格式化成功 (Verible)!"))
            (display-buffer err-buf)
            (message "❌ 格式化拒绝：代码中存在语法错误或找不到宏定义，请见 %s" err-buf)))
      (indent-region (point-min) (point-max))
      (message "✅ 文件已缩进 (传统模式)"))))

(defun my/verilog-generate-filelist ()
  "Generate verible.filelist for current project to resolve macro & UVM indexing."
  (interactive)
  (let ((default-directory (or (locate-dominating-file default-directory ".git")
                               default-directory)))
    (if (executable-find "gen-verible-project.sh")
        (progn
          (message "🔍 正在扫描项目并生成 verible.filelist...")
          (shell-command "gen-verible-project.sh")
          (when (fboundp 'eglot-reconnect)
            (ignore-errors (call-interactively 'eglot-reconnect)))
          (message "✅ 成功生成 verible.filelist 并更新 LSP 索引！"))
      (message "❌ 未找到 gen-verible-project.sh 脚本"))))

;; ----------------------------------------------------------------------
;; Verilog Control Center (Transient)
;; ----------------------------------------------------------------------
(use-package transient
  :ensure nil
  :config
  (transient-define-prefix my/verilog-menu ()
    "Main Menu for Verilog Development."
    ["--- AUTO Expansion ---"
     ("a" "Expand AUTOs" verilog-auto)
     ("d" "Delete AUTOs" verilog-delete-auto)
     ("i" "Inject AUTOs" verilog-inject-auto)]
    ["--- Code Quality & LSP ---"
     ("l" "Flycheck List" flycheck-list-errors)
     ("v" "Verilator Lint" (lambda () (interactive) (compile "verilator --lint-only -Wall %f")))
     ("f" "Format Code (Verible)" my/verilog-format)
     ("p" "Gen Project Filelist (+incdir)" my/verilog-generate-filelist)
     ("r" "LSP Rename" eglot-rename)]
    ["--- Documentation ---"
     ("h" "Header Template" verilog-header)]
    ["--- Build & Sim ---"
     ("c" "Compile / Lint" compile)
     ("w" "GTKWave" (lambda () (interactive) (start-process "gtkwave" nil "gtkwave")))
     ("s" "Shell" eat)]))

(provide 'init-verilog)
;;; init-verilog.el ends here
