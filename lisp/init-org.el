;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org Mode Configuration - 2026 Advanced Professional Setup
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :ensure t
  :hook ((org-mode . org-indent-mode)
         (org-mode . visual-line-mode))
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ;; 快捷跳转：跳回上一个位置
         ("M-[" . org-mark-ring-goto)
         ("M-]" . org-open-at-point))
  :config
  ;; 让跳转更顺滑：如果是链接则跳转，如果是目录则折叠
  (setq org-return-follows-link t)
  ;; --- 1. Core Directory ---
  (setq org-directory "~/org"
        org-roam-directory (expand-file-name "roam" org-directory)
        org-default-notes-file (expand-file-name "inbox.org" org-directory))
  
  ;; Ensure directories exist
  (make-directory org-directory t)
  (make-directory org-roam-directory t)

  ;; --- 2. Advanced Task Workflow ---
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROG(p!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANC(c@)")))

  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "#5E81AC" :weight bold))
          ("PROG" . (:foreground "#81A1C1" :weight bold))
          ("WAIT" . (:foreground "#EBCB8B" :weight bold))
          ("DONE" . (:foreground "#A3BE8C" :weight bold))
          ("CANC" . (:foreground "#4C566A" :weight bold))))

  ;; Logbook settings
  (setq org-log-done 'time
        org-log-into-drawer t
        org-log-redeadline 'note
        org-log-reschedule 'note)

  ;; --- 3. UI & Aesthetics (Modernized) ---
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-hide-leading-stars t
        org-image-actual-width nil
        org-adapt-indentation t
        org-use-sub-superscripts '{})

;; --- 3.5 Org-Appear: 智能显示/隐藏标记 ---
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t   ;; 自动显示加粗/斜体标记
        org-appear-autolinks t     ;; 自动显示链接源码
        org-appear-autosubmarkers t)) ;; 自动显示下标标记

;; --- 4. Capture Templates (Workflow Oriented) ---
  (setq org-capture-templates
        `(("t" "Todo [待办]" entry (file+headline "inbox.org" "Tasks")
           "* TODO %?\n  SCHEDULED: %t\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %a" :empty-lines 1)
          ("n" "Note [随手记]" entry (file+headline "inbox.org" "Notes")
           "* %?\n  :PROPERTIES:\n  :CREATED: %U\n  :END:\n  %i%a" :empty-lines 1)
          ("j" "Journal [日志]" entry (file+datetree "journal.org")
           "* %U %?\n%i" :empty-lines 1))))

;; --- 5. Org-Modern (Refined UI) ---
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳" "◆")
        org-modern-list '((43 . "➤") (45 . "–") (42 . "•"))
        org-modern-checkbox '((?X . "☑") (?  . "☐") (?- . "❍"))
        org-modern-table nil))

;; --- 6. Org-Roam (The Second Brain) ---
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  (org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode)
  
  ;; 让搜索界面显示标签 (Tags)
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:30}" 'face 'org-tag)))

  ;; Templates for different types of notes
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "%<%Y%m%d>-${slug}.org" "#+title: ${title}\n#+filetags: \n\n")
           :unnarrowed t)
          ("p" "project" plain "* Goals\n\n%?\n\n* Tasks\n\n"
           :target (file+head "projects/%<%Y%m%d>-${slug}.org" "#+title: ${title}\n#+filetags: :Project:\n\n")
           :unnarrowed t))))

;; --- 7. Super Agenda (Task Management Master) ---
(use-package org-super-agenda
  :ensure t
  :hook (org-agenda-mode . org-super-agenda-mode)
  :config
  (setq org-super-agenda-groups
        '((:name "🔥 High Priority" :priority "A")
          (:name "📅 Due Today" :deadline today)
          (:name "⏰ Overdue" :deadline past)
          (:name "🏗 In Progress" :todo "PROG")
          (:name "⏳ Waiting" :todo "WAIT")
          (:name "📌 Projects" :tag "Project")
          (:name "📂 Work" :category "Work")
          (:name "🏠 Personal" :category "Personal")
          (:discard (:everything t)))))

;; --- 8. Consult & QL Integration ---
(use-package consult-org-roam
  :ensure t
  :after org-roam
  :init (consult-org-roam-mode 1)
  :bind (("C-c n s" . consult-org-roam-search)
         ("C-c n b" . consult-org-roam-backlinks)))

(use-package org-ql
  :ensure t)

;; --- 9. Extra UI Helpers ---
(use-package visual-fill-column
  :ensure t
  :hook (org-mode . visual-fill-column-mode)
  :config
  (setq visual-fill-column-center-text t
        visual-fill-column-width 110))

(use-package valign
  :ensure t
  :hook (org-mode . valign-mode))

(provide 'init-org)

;;; init-org.el ends here
