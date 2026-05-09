;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Miscellaneous Tools & Smart Editing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Which-key: Displays available keybindings in popup
(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

;; 2. Recentf: Track recent files
(use-package recentf
  :init (recentf-mode 1)
  :config
  (setq recentf-max-menu-items 25
        recentf-max-saved-items 25))

;; 3. Smartparens: Auto-pairing & Jumping
(use-package smartparens
  :ensure t
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config)
  ;; SystemVerilog Support
  (sp-with-modes '(verilog-mode)
    (sp-local-pair "begin" "end"         :actions '(insert navigate))
    (sp-local-pair "class" "endclass"    :actions '(insert navigate))
    (sp-local-pair "module" "endmodule"  :actions '(insert navigate))
    (sp-local-pair "task" "endtask"      :actions '(insert navigate))
    (sp-local-pair "function" "endfunction" :actions '(insert navigate))
    (sp-local-pair "covergroup" "endgroup" :actions '(insert navigate)))
  :bind
  (:map smartparens-mode-map
        ("C-M-f" . sp-forward-sexp)
        ("C-M-b" . sp-backward-sexp)
        ("C-%" . my/smart-jump-match)))

;; Custom Helper Function for "Magic Jump" (C-%)
(defun my/smart-jump-match ()
  "Smartly jump to the matching parenthesis or keyword."
  (interactive)
  (cond
   ((looking-at "\\s\(") (sp-forward-sexp))
   ((looking-at "\\s\)") (sp-backward-sexp))
   ((derived-mode-p 'verilog-mode)
    (let ((pt (point)))
      (verilog-forward-sexp)
      (when (= pt (point))
        (verilog-backward-sexp))))
   (t (sp-backward-up-sexp))))

;; ----------------------------------------------------------------------
;; 4. Avy: Fast Cursor Movement (Jump to anywhere)
;; ----------------------------------------------------------------------
;; Usage:
;; 1. Press M-j (Jump to char timer - search as you type)
;; 2. Press M-s j (Jump to a single char)
;; 3. Press M-s w (Jump to a word start)
(use-package avy
  :ensure t
  :bind (("M-j"   . avy-goto-char-timer)
         ("M-s j" . avy-goto-char)
         ("M-s w" . avy-goto-word-1)
         ("M-g l" . avy-goto-line))
  :config
  (setq avy-timeout-seconds 0.3
        avy-all-windows t)) ;; 允许跨窗口跳转

;; ----------------------------------------------------------------------
;; 5. Winum: Window Switching with Alt + Number
;; ----------------------------------------------------------------------
;; Usage: M-1 selects window 1, M-2 selects window 2, etc.
(use-package winum
  :ensure t
  :init (winum-mode)
  :config
  ;; Allow M-0 to select window 10 (or 0 if exists)
  (setq winum-auto-assign-0-to-10 t)
  :bind (("M-1" . winum-select-window-1)
         ("M-2" . winum-select-window-2)
         ("M-3" . winum-select-window-3)
         ("M-4" . winum-select-window-4)
         ("M-5" . winum-select-window-5)
         ("M-6" . winum-select-window-6)
         ("M-7" . winum-select-window-7)
         ("M-8" . winum-select-window-8)
         ("M-0" . winum-select-window-0-or-10)))

;; ----------------------------------------------------------------------
;; 6. Find File At Point (FFAP)
;; ----------------------------------------------------------------------
;; Automatically guesses the file path at cursor when running C-x C-f.
;; Great for jumping to 'include "foo.svh"' files.
(use-package ffap
  :ensure nil
  :bind ("C-c f" . ffap)) ; Bind C-c f to directly open file at point

;; ----------------------------------------------------------------------
;; 7. Multiple Cursors: Edit multiple lines/matches simultaneously
;; ----------------------------------------------------------------------
;; Usage:
;; ----------------------------------------------------------------------
;; 7. Multiple Cursors: Edit multiple lines/matches simultaneously
;; ----------------------------------------------------------------------
;; Usage:
;; - C-> / C-. : Mark next instance of current word/region (Smart)
;; - C-< / C-, : Mark previous instance (Smart)
;; - C-c C-< : Mark all instances
;; - C-S-c C-S-c : Edit all lines in the current region

(require 'thingatpt)

(defun my/mc-mark-next-like-this ()
  "Select word at point if no region is active, then mark next like this.
If no word is found, just add a cursor at the next line."
  (interactive)
  (if (region-active-p)
      (mc/mark-next-like-this 1)
    (let ((range (bounds-of-thing-at-point 'word)))
      (if range
          (progn
            (set-mark (car range))
            (goto-char (cdr range))
            (mc/mark-next-like-this 1))
        ;; Fallback: if no word, just use the default behavior (add cursor below)
        (mc/mark-next-like-this 1)))))

(defun my/mc-mark-previous-like-this ()
  "Select word at point if no region is active, then mark previous like this.
If no word is found, just add a cursor at the previous line."
  (interactive)
  (if (region-active-p)
      (mc/mark-previous-like-this 1)
    (let ((range (bounds-of-thing-at-point 'word)))
      (if range
          (progn
            (set-mark (car range))
            (goto-char (cdr range))
            (mc/mark-previous-like-this 1))
        ;; Fallback
        (mc/mark-previous-like-this 1)))))

(use-package multiple-cursors
  :ensure t
  :commands (mc/edit-lines mc/mark-all-like-this mc/mark-all-dwim)
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-M-m"       . mc/mark-all-dwim)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)
         ;; Bind the smart versions
         ("C->" . my/mc-mark-next-like-this)
         ("C-<" . my/mc-mark-previous-like-this)
         ("C-." . my/mc-mark-next-like-this)
         ("C-," . my/mc-mark-previous-like-this)))

;; ----------------------------------------------------------------------
;; 8. Symbol Overlay: Highlight symbols and jump between them
;; ----------------------------------------------------------------------
;; Usage:
;; - M-i : Toggle highlight for symbol at point
;; - n / p : Move to next/previous highlight (when overlay is active)
;; - M-s n / M-s p : Global jump to next/previous occurrence
(use-package symbol-overlay
  :ensure t
  :bind (("M-i" . symbol-overlay-put)
         ("M-n" . symbol-overlay-jump-next)
         ("M-p" . symbol-overlay-jump-prev)
         ("M-s n" . symbol-overlay-switch-forward)
         ("M-s p" . symbol-overlay-switch-backward))
  :hook (prog-mode . symbol-overlay-mode))

(provide 'init-misc)
;;; init-misc.el ends here
