;;; -*- lexical-binding: t -*-
;;; package --- Summary
;;; Commentary:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Emacs Configuration Entry Point
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 0. Warning Suppression
(setq native-comp-async-report-warnings-errors 'silent
      byte-compile-warnings nil
      warning-suppress-types '((bytecomp) (native-compiler) (treesit) (files)))

;; 1. Path Configuration
;;; Add the 'lisp' directory to the load path so we can require our modules.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;;; Add the 'bin' directory to exec-path and PATH for portable executables.
(add-to-list 'exec-path (expand-file-name "bin" user-emacs-directory))
(setenv "PATH" (concat (expand-file-name "bin" user-emacs-directory) ":" (getenv "PATH")))

;; 1.5 Offline Check
(when (file-exists-p (expand-file-name "offline" user-emacs-directory))
  (require 'init-offline))

;; 2. Load Modules (Core Immediate + Language/Tools On-Demand)
;; 2.1 核心常驻模块（启动即用）
(require 'init-proxy)       ; 网络代理配置
(require 'init-packages)    ; 包管理基础
(require 'init-core)        ; 核心编辑体验与备份
(require 'init-stats)       ; 命令使用统计
(require 'init-ui)          ; 字体、主题与视觉
(require 'init-completion)  ; 补全体系 (Vertico + Orderless + Corfu)
(require 'init-dev)         ; 核心开发工具 (Magit, Apheleia 等)
(require 'init-fold)        ; Tree-sitter AST 结构化代码折叠 (C-c RET / C-c Y)
(require 'init-misc)        ; 实用编辑命令 (Avy, Smartparens 等)

;; 2.2 语言与特定工具按需懒加载 (On-Demand Loading)
;; 仅在打开对应文件或按下快捷键时才动态加载，大幅减少启动负担与内存占用
(defun my/register-lazy-mode (patterns module mode-fn)
  "关联文件后缀 PATTERNS，打开文件时才动态加载 MODULE 并执行 MODE-FN。
自动优先查询 `major-mode-remap-alist`，在 Tree-sitter 可用时无缝升级到 ts-mode。"
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist
                 (cons pattern
                       (lambda ()
                         (when module (require module nil t))
                         (let ((real-mode (or (alist-get mode-fn major-mode-remap-alist)
                                              mode-fn)))
                           (when (fboundp real-mode)
                             (funcall real-mode))))))))

(defun my/register-lazy-keys (key-bindings module)
  "为 KEY-BINDINGS 绑定延迟加载，按下快捷键时加载 MODULE 并重放命令。"
  (dolist (pair key-bindings)
    (let ((key (car pair))
          (cmd (cdr pair)))
      (global-set-key (kbd key)
                      (lambda ()
                        (interactive)
                        (require module)
                        (call-interactively cmd))))))

;; A. Verilog & SystemVerilog (硬件设计核心)
(my/register-lazy-mode '("\\.v\\'" "\\.sv\\'" "\\.svh\\'")
                       'init-verilog
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'systemverilog t))
                           'verilog-ts-mode
                         'verilog-mode))
(my/register-lazy-keys '(("C-c v" . my/verilog-format)) 'init-verilog)

;; B. Org Mode & Org-Roam (笔记与任务看板)
(my/register-lazy-mode '("\\.org\\'" "\\.org_archive\\'") 'init-org 'org-mode)
(my/register-lazy-keys '(("C-c a" . org-agenda)
                         ("C-c c" . org-capture)
                         ("C-c l" . org-store-link)
                         ("C-c n f" . org-roam-node-find)
                         ("C-c n i" . org-roam-node-insert)
                         ("C-c n l" . org-roam-buffer-toggle))
                       'init-org)

;; C. Markdown
(my/register-lazy-mode '("\\.md\\'" "\\.markdown\\'") 'init-markdown 'markdown-mode)

;; D. C/C++ & SystemC
(my/register-lazy-mode '("\\.c\\'")
                       'init-cpp
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'c t))
                           'c-ts-mode
                         'c-mode))
(my/register-lazy-mode '("\\.cpp\\'" "\\.cxx\\'" "\\.cc\\'" "\\.h\\'" "\\.hpp\\'")
                       'init-cpp
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'cpp t))
                           'c++-ts-mode
                         'c++-mode))
(my/register-lazy-mode '("\\.sc\\'" "\\.systemc\\'")
                       'init-systemc
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'cpp t))
                           'c++-ts-mode
                         'c++-mode))

;; E. 脚本与配置语言 (Shell / Rust / YAML / TOML / Python / JSON / Tcl / Perl / Jinja2)
(my/register-lazy-mode '("\\.py\\'")
                       nil
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'python t))
                           'python-ts-mode
                         'python-mode))
(my/register-lazy-mode '("\\.json\\'")
                       nil
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'json t))
                           'json-ts-mode
                         'js-json-mode))
(my/register-lazy-mode '("\\.sh\\'" "\\.bash\\'" "\\.csh\\'" "\\.tcsh\\'" "\\.[tc]*csh\\(rc\\)?\\'")
                       'init-shell
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'bash t))
                           'bash-ts-mode
                         'sh-mode))
(my/register-lazy-mode '("\\.rs\\'")
                       'init-rust
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'rust t))
                           'rust-ts-mode
                         'rust-mode))
(my/register-lazy-mode '("\\.ya?ml\\'")
                       'init-yaml
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'yaml t))
                           'yaml-ts-mode
                         'yaml-mode))
(my/register-lazy-mode '("\\.toml\\'" "\\.kemurc\\'")
                       'init-toml
                       (if (and (fboundp 'treesit-ready-p)
                                (treesit-ready-p 'toml t))
                           'toml-ts-mode
                         'conf-toml-mode))
(my/register-lazy-mode '("\\.tcl\\'" "\\.exp\\'" "\\.itcl\\'" "\\.qel\\'") 'init-tcl 'tcl-mode)
(my/register-lazy-mode '("\\.p[lm]\\'" "\\.t\\'" "\\.perl\\'") 'init-perl 'cperl-mode)
(my/register-lazy-mode '("\\.jinja2?\\'" "\\.j2\\'") 'init-jinja2 'jinja2-mode)

;; F. 调试与远程工具 (Dape / Tramp)
(my/register-lazy-keys '(("<f5>" . dape-continue)
                         ("<f9>" . dape-breakpoint-toggle)
                         ("C-x t d" . dape))
                       'init-debug)
(my/register-lazy-keys '(("C-c R" . my/find-remote-file)) 'init-tramp)

;; 3. Startup Profiler

;; Display startup time, restore file-name-handler-alist, and reset GC threshold.
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; 恢复文件处理器
            (when (boundp 'my/saved-file-name-handler-alist)
              (setq file-name-handler-alist
                    (delete-dups (append file-name-handler-alist my/saved-file-name-handler-alist))))
            ;; 恢复运行时垃圾回收阈值
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; 4. Custom File
;; Keep automatic custom settings in a separate file to keep init.el clean.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; 5. Local configuration
;; Load machine-specific settings that should not be tracked by git.
(let ((local-config (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-config)
    (load local-config)))

;;; init.el ends here
