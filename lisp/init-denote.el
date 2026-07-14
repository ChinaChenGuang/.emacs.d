;;; init-denote.el --- Setup denote -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package denote
  :ensure t
  :hook
  (dired-mode . denote-dired-mode)
  :custom
  ;; 指定您的笔记目录
  (denote-directory (expand-file-name "~/Notes"))
  ;; 设置默认的笔记扩展名，支持 org, markdown-yaml, markdown-toml, text
  (denote-file-type 'org)
  ;; 常用标签，输入时会自动提示
  (denote-known-keywords '("emacs" "note" "todo" "work"))
  ;; 自动推断曾经用过的标签
  (denote-infer-keywords t)
  ;; 按字母顺序排序标签
  (denote-sort-keywords t)
  ;; 新建笔记时的提示顺序：标题、标签
  (denote-prompts '(title keywords))
  ;; 在日记和其它需要输入日期的地方，使用 org-mode 的日期选择界面
  (denote-date-prompt-use-org-read-date t)

  :bind
  (;; 全局快捷键前缀 C-c n (Note)
   ("C-c n n" . denote)                   ; 新建笔记
   ("C-c n j" . denote-journal-extras-new-or-existing-entry) ; 新建或打开今日日记
   ("C-c n o" . denote-open-or-create)    ; 打开或新建笔记 (可用于全局搜索笔记)
   ("C-c n i" . denote-link-or-create)    ; 在当前笔记中插入指向另一篇笔记的链接 (不存在则新建)
   ("C-c n I" . denote-add-links)         ; 批量插入多个链接
   ("C-c n b" . denote-backlinks)         ; 显示当前笔记的"反向链接" (哪些笔记引用了这篇)
   ("C-c n f" . denote-find-file)         ; 搜索笔记
   ("C-c n r" . denote-rename-file)       ; 重命名笔记并自动更新文件名格式
   ("C-c n R" . denote-rename-file-using-front-matter))) ; 根据文件内容(Front matter)自动重命名文件

;; 配置 Consult-denote (可选，但推荐。如果您安装了 consult，它能提供非常棒的搜索和过滤体验)
(use-package consult-denote
  :ensure t
  :after (denote consult)
  :bind
  (("C-c n f" . consult-denote-find)      ; 替换默认的搜索为 consult 版本
   ("C-c n g" . consult-denote-grep)))    ; 全文搜索笔记

(provide 'init-denote)
;;; init-denote.el ends here
