;;; init-stats.el --- 命令使用统计（用于裁剪不常用配置） -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; 记录每个交互命令的执行次数，积累一段时间后用统计结果决定哪些包/功能可以关闭。
;; 数据保存在 var/command-stats.el，正常退出 Emacs 时自动写入。
;;
;;   M-x my/stats-show              查看命令次数排行
;;   M-x my/stats-report-packages   对照配置中的 use-package 列出有无使用记录
;;   M-x my/stats-save              手动保存
;;
;;; Code:

(defcustom my/stats-file
  (expand-file-name "var/command-stats.el" user-emacs-directory)
  "命令统计数据文件。"
  :type 'file
  :group 'convenience)

(defcustom my/stats-exclude
  '(self-insert-command
    newline newline-and-indent electric-newline-and-maybe-indent
    delete-backward-char delete-forward-char
    next-line previous-line forward-char backward-char
    move-beginning-of-line move-end-of-line
    scroll-up-command scroll-down-command
    beginning-of-buffer end-of-buffer
    keyboard-quit handle-switch-frame
    mouse-set-point mouse-drag-region mouse-select-window)
  "不参与统计的高频基础命令（否则统计会被它们占满）。"
  :type '(repeat symbol)
  :group 'convenience)

(defvar my/stats-table (make-hash-table :test 'equal)
  "命令名（字符串）到执行次数的哈希表。")

(defvar my/stats-dirty nil
  "自上次保存后是否有新记录。")

(defun my/stats--record ()
  "记录当前命令。挂在 `post-command-hook'。"
  (when (and (symbolp this-command)
             (not (memq this-command my/stats-exclude)))
    (let ((key (symbol-name this-command)))
      (puthash key (1+ (gethash key my/stats-table 0)) my/stats-table)
      (setq my/stats-dirty t))))

(defun my/stats-save ()
  "把统计写入 `my/stats-file'。"
  (interactive)
  (when my/stats-dirty
    (let (entries)
      (maphash (lambda (k v) (push (cons k v) entries)) my/stats-table)
      (setq entries (sort entries (lambda (a b) (> (cdr a) (cdr b)))))
      (with-temp-file my/stats-file
        (insert ";; 命令使用统计，自动生成，请勿手工编辑。\n")
        (insert "(setq my/stats-table (make-hash-table :test 'equal))\n")
        (dolist (e entries)
          (insert (format "(puthash %S %d my/stats-table)\n" (car e) (cdr e))))
        (setq my/stats-dirty nil)))))

(defun my/stats--load ()
  "加载已有统计数据。"
  (when (file-exists-p my/stats-file)
    (load my/stats-file nil t)))

(defun my/stats-show (&optional n)
  "显示使用次数最多的 N 个命令（默认 40）。"
  (interactive "n显示前多少个命令: ")
  (let ((limit (or n 40))
        (entries nil))
    (maphash (lambda (k v) (push (cons k v) entries)) my/stats-table)
    (setq entries (sort entries (lambda (a b) (> (cdr a) (cdr b))))
          limit (min limit (length entries)))
    (with-current-buffer (get-buffer-create "*命令统计*")
      (erase-buffer)
      (insert (format "%-50s%s\n" "命令" "次数"))
      (insert "------------------------------------------------------------\n")
      (dotimes (i limit)
        (let ((e (nth i entries)))
          (insert (format "%-50s%d\n" (car e) (cdr e)))))
      (goto-char (point-min))
      (display-buffer (current-buffer)))))

(defun my/stats--configured-packages ()
  "返回配置目录 lisp/*.el 中所有 use-package 的包名。"
  (let ((dir (expand-file-name "lisp" user-emacs-directory))
        (names nil))
    (dolist (f (directory-files dir t "\\.el$"))
      (with-temp-buffer
        (insert-file-contents f)
        (goto-char (point-min))
        (while (re-search-forward "\\(use-package[ \t]+\\([^ \t\n()]+\\)\\)" nil t)
          (push (match-string-no-properties 2) names))))
    (sort (delete-dups names) #'string<)))

(defun my/stats--package-used-p (pkg)
  "统计表里是否有以 PKG 为前缀的命令记录。"
  (let ((prefix (concat pkg "-"))
        (hit nil))
    (maphash (lambda (k _v)
               (when (or (string= k pkg) (string-prefix-p prefix k))
                 (setq hit t)))
             my/stats-table)
    hit))

(defun my/stats--report-buffer (used unused)
  "生成并显示包使用报告。"
  (with-current-buffer (get-buffer-create "*包使用报告*")
    (erase-buffer)
    (insert (format "=== 有命令使用记录（%d）===\n" (length used)))
    (dolist (p used) (insert (format "  %s\n" p)))
    (insert (format "\n=== 无命令使用记录（%d）===\n" (length unused)))
    (dolist (p unused) (insert (format "  %s\n" p)))
    (insert "\n注意：基础设施/被动生效的包（no-littering、persist、diff-hl 等）\n"
            "本来就没有可统计的命令，不能仅凭这里的结果删除。\n")
    (goto-char (point-min))
    (display-buffer (current-buffer))))

(defun my/stats-report-packages ()
  "对照配置里的 use-package 与统计记录，列出有无使用。"
  (interactive)
  (let ((used nil)
        (unused nil))
    (dolist (p (my/stats--configured-packages))
      (if (my/stats--package-used-p p)
          (push p used)
        (push p unused)))
    (my/stats--report-buffer (sort used #'string<) (sort unused #'string<))))

;;; 初始化
(my/stats--load)

(defun my/stats--enable-local ()
  "在当前 buffer 注册统计。
`post-command-hook' 是 buffer-local 变量，只 add-hook 到当前 buffer 不会覆盖所有 buffer。"
  (add-hook 'post-command-hook #'my/stats--record nil t))

;; 每个 buffer 设置 major mode 时都注册一次
(add-hook 'after-change-major-mode-hook #'my/stats--enable-local)
;; 启动时的 *scratch* buffer
(my/stats--enable-local)
;; 所有已存在的 buffer
(dolist (buf (buffer-list))
  (with-current-buffer buf
    (my/stats--enable-local)))

(add-hook 'kill-emacs-hook #'my/stats-save)

(provide 'init-stats)
;;; init-stats.el ends here
