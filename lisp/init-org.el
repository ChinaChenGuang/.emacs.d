;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org Mode Configuration - Clean & Stable Modern Setup
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :hook ((org-mode . org-indent-mode)      ; Built-in stable indentation
         (org-mode . visual-line-mode))    ; Soft wrapping
  :config
  ;; --- 1. Core Stability Settings ---
  (setq org-ellipsis " ▾"                  ; Clean folding symbol
        org-hide-emphasis-markers t        ; Hide * / _ markers
        org-pretty-entities t              ; Show \alpha as α
        org-hide-leading-stars t           ; Hide redundant stars for a clean look
        org-image-actual-width nil         ; Smart image resizing
        org-use-sub-superscripts '{})      ; Don't auto-subscript underscores

  ;; --- 2. Code Blocks ---
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-confirm-babel-evaluate nil)

  ;; --- 3. Task Workflow ---
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROG(p!)" "WAIT(w@)" "|" "DONE(d!)" "CANC(k@)")))

  ;; Clean & Stable Colors for TODOs (No hacks, just colors)
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "#5E81AC" :weight bold))
          ("PROG" . (:foreground "#EBCB8B" :weight bold))
          ("WAIT" . (:foreground "#BF616A" :weight bold))
          ("DONE" . (:foreground "#A3BE8C" :weight bold))
          ("CANC" . (:foreground "#4C566A" :weight bold))))

  ;; --- 4. Progress Tracking ---
  (setq org-hierarchical-todo-statistics nil
        org-checkbox-hierarchical-statistics nil))

;; --------------------------------------------------------------------------
;; 5. Org-Modern: Single Source for Modern UI
;; --------------------------------------------------------------------------
;; This handles Stars, Checkboxes, and Statistics in one unified engine.
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq 
   ;; Headlines (Bullets)
   org-modern-star '("◉" "○" "◈" "◇" "✳" "◆")
   ;; Checkboxes
   org-modern-checkbox '((?X . "☑") (?  . "☐") (?- . "❍"))
   ;; Progress Cookies (Visual Badges)
   org-modern-statistics t
   org-modern-progress '("○" "◔" "◑" "◕" "●")
   ;; Lists and Tables
   org-modern-list '((43 . "➤") (45 . "–") (42 . "•"))
   org-modern-table nil ; Valign is better for tables
   ;; Minimalist Labels (Optional: Set to nil if you want zero labels)
   org-modern-todo t
   org-modern-tag t
   org-modern-priority t))

;; --------------------------------------------------------------------------
;; 6. Layout & Table Alignment (The Professional Essentials)
;; --------------------------------------------------------------------------
(use-package visual-fill-column
  :ensure t
  :hook (org-mode . visual-fill-column-mode)
  :config
  (setq visual-fill-column-center-text t
        visual-fill-column-width 100))

(use-package valign
  :ensure t
  :hook (org-mode . valign-mode)
  :config
  (setq valign-fancy-bar nil))

(provide 'init-org)
;;; init-org.el ends here
