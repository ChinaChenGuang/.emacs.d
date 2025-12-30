;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Miscellaneous Tools & Smart Editing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Which-key: Displays available keybindings in popup
(use-package which-key
  :init (which-key-mode)
  :config
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
;; 1. Press M-j (Alt + j)
;; 2. Type 1 or 2 characters of the word you want to jump to.
;; 3. Avy will show a letter overlay on matches. Type that letter to jump.
(use-package avy
  :ensure t
  :bind (("M-j" . avy-goto-char-timer)
         ("M-g l" . avy-goto-line))) ;; M-g l to jump to a specific line number

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

(provide 'init-misc)
;;; init-misc.el ends here
