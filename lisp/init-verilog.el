;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Verilog & SystemVerilog Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my/verilog-style-setup ()
  "Custom style for Verilog and SystemVerilog."
  ;; 1. Indentation Settings (Set to 2 spaces)
  (setq-local verilog-indent-level 2)
  (setq-local verilog-indent-level-module 2)
  (setq-local verilog-indent-level-declaration 2)
  (setq-local verilog-indent-level-behavioral 2)
  (setq-local verilog-indent-level-directive 1) ; 宏指令缩进：1=跟随代码块，0=顶格(Column 0)
  (setq-local verilog-case-indent 2)
  (setq-local verilog-cexp-indent 2)
  (setq-local verilog-indent-lists 2)
  
  ;; verilog-ts-mode specific (Tree-sitter)
  (setq-local verilog-ts-indent-level 2)
  
  ;; Ensure spaces instead of tabs
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 2)
  (setq-local backward-delete-char-untabify-method 'hungry)

  ;; 2. Disable Auto-newline after semicolon
  (setq-local verilog-auto-newline nil)
  (setq-local verilog-auto-lineup nil))

;; Apply to Classic Verilog Mode (Stable & Basic)
(use-package verilog-mode
  :ensure nil ; Built-in
  :mode ("\\.v\\'" "\\.sv\\'" "\\.svh\\'")
  :hook ((verilog-mode . my/verilog-style-setup)
         (verilog-ts-mode . my/verilog-style-setup))
  :bind (:map verilog-mode-map
              ("C-c v" . my/verilog-menu)) ; 定义控制中心快捷键
  :config
  (setq verilog-indent-level 2)
  (setq verilog-indent-level-module 2)
  (setq verilog-indent-level-declaration 2)
  (setq verilog-indent-level-behavioral 2)
  (setq verilog-indent-level-directive 1) ; 1=跟随缩进，0=顶格
  (setq verilog-case-indent 2)
  (setq verilog-auto-newline nil))

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
              (if (eq 0 (call-process-region start end "verible-verilog-format" t t nil "-" "--column_limit=100" "--indentation_spaces=2"))
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
          (if (eq 0 (call-process-region (point-min) (point-max) "verible-verilog-format" nil (list t err-buf) nil "-" "--column_limit=100" "--indentation_spaces=2"))
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
  :ensure t
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

;; Tree-sitter specific enhancement for Verilog
(use-package verilog-ts-mode
  :defer t
  :config
  (setq verilog-ts-indent-level 2))

(provide 'init-verilog)
;;; init-verilog.el ends here
