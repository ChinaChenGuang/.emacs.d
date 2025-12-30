;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Org Mode Configuration - Visual Beautification
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :hook ((org-mode . org-indent-mode)      ; Auto indentation (cleaner look)
         (org-mode . visual-line-mode))    ; Soft wrapping for long lines
  :config
  ;; --------------------------------------------------------------------------
  ;; 1. Core Visual Tweaks
  ;; --------------------------------------------------------------------------
  (setq org-ellipsis " ▾")                 ; Replace the "..." at end of folded headers
  (setq org-hide-emphasis-markers t)       ; Hide markers! *bold* -> bold, /italic/ -> italic
  (setq org-pretty-entities t)             ; Render \alpha as α, \to as →
  (setq org-image-actual-width nil)        ; Allow resizing images in org buffers

  ;; CRITICAL FIX FOR PROGRAMMERS (SystemVerilog, Python, etc.)
  ;; Prevent underscores from creating subscripts (e.g., m_sequencer).
  (setq org-use-sub-superscripts '{})

  ;; --------------------------------------------------------------------------
  ;; 2. Source Code Blocks (The "IDE" feel)
  ;; --------------------------------------------------------------------------
  (setq org-src-fontify-natively t)        ; Syntax highlighting inside code blocks
  (setq org-src-tab-acts-natively t)       ; Tab works as expected inside blocks
  (setq org-edit-src-content-indentation 0); Align code with the block header (no extra indent)
  (setq org-confirm-babel-evaluate nil)    ; Run code blocks without annoying confirmation

  ;; --------------------------------------------------------------------------
  ;; 3. Task Workflow (Geek Style)
  ;; --------------------------------------------------------------------------
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROG(p!)" "WAIT(w@)" "|" "DONE(d!)" "CANC(k@)")))

  ;; Custom colors for TODO keywords to make them pop
  (setq org-todo-keyword-faces
        '(("PROG" . (:foreground "#EBCB8B" :weight bold))  ; Yellow
          ("WAIT" . (:foreground "#BF616A" :weight bold))  ; Red
          ("CANC" . (:foreground "#4C566A" :weight bold))  ; Grey
          ("DONE" . (:foreground "#A3BE8C" :weight bold)))); Green

  ;; --------------------------------------------------------------------------
  ;; 4. Typography (Font Sizes)
  ;; --------------------------------------------------------------------------
  ;; Make headings larger to create a document structure hierarchy
  (custom-set-faces
   '(org-level-1 ((t (:height 1.3 :weight bold))))
   '(org-level-2 ((t (:height 1.15 :weight bold))))
   '(org-level-3 ((t (:height 1.05 :weight bold))))
   '(org-level-4 ((t (:height 1.0 :weight bold))))
   '(org-document-title ((t (:height 1.5 :weight bold :underline nil))))))

;; --------------------------------------------------------------------------
;; 5. Modern UI (Replacing Superstars with org-modern)
;; This provides Notion-like badges, styled blocks, and clean bullets.
;; --------------------------------------------------------------------------
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳" "◆")
        org-modern-hide-stars nil ; Keep the stars for structure, or set t to hide
        org-modern-table nil      ; Let valign handle tables (it's better for mixed fonts)
        org-modern-list '((43 . "➤") (45 . "–") (42 . "•"))
        org-modern-todo nil       ; Use our custom colored faces defined above
        org-modern-tag t
        org-modern-priority t
        org-modern-block-fringe nil)) ; No extra fringe

;; --------------------------------------------------------------------------
;; 6. Reading Experience (Centered & Margins)
;; --------------------------------------------------------------------------
(use-package visual-fill-column
  :ensure t
  :hook (org-mode . visual-fill-column-mode)
  :config
  (setq visual-fill-column-center-text t
        visual-fill-column-width 120))

;; --------------------------------------------------------------------------
;; 7. Table Alignment (Valign) - PIXEL PERFECT
;; --------------------------------------------------------------------------
(use-package valign
  :ensure t
  :hook (org-mode . valign-mode)
  :config
  ;; Disable fancy-bar to ensure borders are visible (Fixes "No Border" issue)
  ;; When enabled on Windows, the separator line sometimes becomes invisible.
  (setq valign-fancy-bar nil)
  
  ;; Force the table lines to be visible and colored (Cyan)
  (custom-set-faces
   '(org-table ((t (:foreground "#88C0D0"))))))

(provide 'init-org)
;;; init-org.el ends here
