;;; init-treesit.el --- Native Tree-sitter Support -*- lexical-binding: t -*-

;; 1. 基础配置
;; 只有 Emacs 29+ 支持原生 treesit
(when (and (fboundp 'treesit-available-p)
           (treesit-available-p))
  
  ;; 2. 映射传统模式到 TS 模式
  (setq major-mode-remap-alist
        '((c-mode          . c-ts-mode)
          (c++-mode        . c++-ts-mode)
          (c-or-c++-mode   . c-or-c++-ts-mode)
          (java-mode       . java-ts-mode)
          (js-mode         . js-ts-mode)
          (json-mode       . json-ts-mode)
          (css-mode        . css-ts-mode)
          (python-mode     . python-ts-mode)
          (bash-mode       . bash-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (rust-mode       . rust-ts-mode)
          (yaml-mode       . yaml-ts-mode)
          (verilog-mode    . verilog-ts-mode)
          (tcl-mode        . tcl-ts-mode)))

  ;; 3. SystemVerilog TS 支持
  ;; 需要安装 verilog-ts-mode 包
  (use-package verilog-ts-mode
    :mode ("\\.v\\'" "\\.sv\\'" "\\.svh\\'")
    :config
    (setq verilog-ts-indent-level 2))

  ;; 4. 自动安装缺失的语言解析器 (仅限联网模式)
  (unless (file-exists-p (expand-file-name "offline" user-emacs-directory))
    (setq treesit-language-source-alist
          '((bash "https://github.com/tree-sitter/tree-sitter-bash")
            (c "https://github.com/tree-sitter/tree-sitter-c")
            (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
            (cmake "https://github.com/tree-sitter/tree-sitter-cmake")
            (css "https://github.com/tree-sitter/tree-sitter-css")
            (elisp "https://github.com/Wilfred/tree-sitter-elisp")
            (go "https://github.com/tree-sitter/tree-sitter-go")
            (html "https://github.com/tree-sitter/tree-sitter-html")
            (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
            (json "https://github.com/tree-sitter/tree-sitter-json")
            (make "https://github.com/alemuller/tree-sitter-make")
            (markdown "https://github.com/ikatyang/tree-sitter-markdown")
            (python "https://github.com/tree-sitter/tree-sitter-python")
            (rust "https://github.com/tree-sitter/tree-sitter-rust")
            (toml "https://github.com/ikatyang/tree-sitter-toml")
            (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
            (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
            (yaml "https://github.com/ikatyang/tree-sitter-yaml")
            (verilog "https://github.com/guregu/tree-sitter-verilog")
            (systemverilog "https://github.com/tree-sitter-grammars/tree-sitter-systemverilog")
            (tcl "https://github.com/tree-sitter-grammars/tree-sitter-tcl"))))


  ;; 5. 快捷键与实用工具
  (with-eval-after-load 'treesit
    (define-key global-map (kbd "C-c T e") #'treesit-explore-mode)
    (define-key global-map (kbd "C-c T i") #'treesit-inspect-mode)))

(provide 'init-treesit)
;;; init-treesit.el ends here
