;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Chinese Input Method Configuration (Pyim)
;;
;; This is specifically for WSL/Terminal environments where system IME
;; might not bridge well into Emacs GUI.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package pyim
  :ensure t
  :demand t
  :config
  ;; 1. Set default input method to pyim
  (setq default-input-method "pyim")

  ;; 2. Use Quanpin (Full Pinyin)
  (setq pyim-default-scheme 'quanpin)

  ;; 3. Candidate Window UI
  ;; Use posframe in GUI mode, and popup in terminal mode
  (if (display-graphic-p)
      (use-package posframe
        :ensure t
        :demand t
        :config (setq pyim-page-tooltip 'posframe))
    (setq pyim-page-tooltip 'popup))

  ;; 4. Visual Tweaks
  (setq pyim-page-length 5) ; Show 5 candidates

  ;; 5. Punctuation handling
  ;; If you want full-width punctuation, keep this.
  ;; Otherwise, you can set it to toggle.
  (setq-default pyim-punctuation-dict nil)

  ;; 6. Keybindings
  :bind
  (("M-j" . pyim-convert-string-at-point) ; Convert pinyin at point to Chinese
   ("C-;" . pyim-delete-word-from-personal-buffer)))

;; Standard Pinyin dictionary (Required for pyim to work)
(use-package pyim-basedict
  :ensure t
  :after pyim
  :config
  (pyim-basedict-enable))

(provide 'init-chinese)
;;; init-chinese.el ends here
