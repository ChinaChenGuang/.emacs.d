;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Development Tools & Multi-Color Global Highlighting (Fixed Jump)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Magit: The best Git client ever
(use-package magit
  :bind ("C-x g" . magit-status))

;; 2. Flycheck: On-the-fly syntax checking
(use-package flycheck
  :init (global-flycheck-mode))

;; 3. iedit: Simultaneous Global Editing (Rename variables instantly)
;; Usage: Press M-e on a variable, then type to rename ALL occurrences at once.
(use-package iedit
  :ensure t
  :bind ("M-e" . iedit-mode))

;; 4. Multi-Color Global Highlighting (Overlay Implementation)
;; ----------------------------------------------------------------------------

;; Define a palette of background-only faces (Transparent Highlighter Pens)
(defface my/highlight-face-1
  '((t (:background "#8B7500" :foreground unspecified))) "Dark Gold")
(defface my/highlight-face-2
  '((t (:background "#8B008B" :foreground unspecified))) "Dark Magenta")
(defface my/highlight-face-3
  '((t (:background "#006400" :foreground unspecified))) "Dark Green")
(defface my/highlight-face-4
  '((t (:background "#00008B" :foreground unspecified))) "Dark Blue")

;; List of faces to cycle through
(defvar my/highlight-faces 
  '(my/highlight-face-1 my/highlight-face-2 my/highlight-face-3 my/highlight-face-4))

;; Global state: List of (SYMBOL-STRING . FACE-NAME)
;; Tracks which symbols are highlighted with which color globally.
(defvar my/active-highlights-alist nil)

(defvar-local my/buffer-overlays nil
  "List of overlays in the current buffer.")

(defun my/refresh-overlays-in-buffer ()
  "Clear and re-apply all overlays in current buffer based on global state."
  ;; 1. Clear existing local overlays
  (mapc 'delete-overlay my/buffer-overlays)
  (setq my/buffer-overlays nil)
  
  ;; 2. Apply all active highlights
  (dolist (item my/active-highlights-alist)
    (let* ((sym (car item))
           (face (cdr item))
           (regexp (concat "\\_<" (regexp-quote sym) "\\_>")))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward regexp nil t)
          (let ((ov (make-overlay (match-beginning 0) (match-end 0))))
            (overlay-put ov 'face face)
            (overlay-put ov 'priority 1000) ; Higher than hl-line
            (push ov my/buffer-overlays)))))))

(defun my/toggle-highlight-at-point ()
  "Toggle highlight for symbol at point. Supports MULTIPLE keywords."
  (interactive)
  (let ((symbol (thing-at-point 'symbol t)))
    (if (not symbol)
        (message "No symbol at point!")
      ;; Check if already highlighted
      (let ((existing (assoc symbol my/active-highlights-alist)))
        (if existing
            ;; CASE A: Already highlighted -> REMOVE it
            (progn
              (setq my/active-highlights-alist 
                    (delete existing my/active-highlights-alist))
              (message "Unhighlighted: %s" symbol))
          
          ;; CASE B: New symbol -> ADD it (pick next color)
          ;; Calculate which color to use based on count
          (let* ((index (% (length my/active-highlights-alist) (length my/highlight-faces)))
                 (face (nth index my/highlight-faces)))
            (push (cons symbol face) my/active-highlights-alist)
            (message "Highlighted: %s (Color %d)" symbol (1+ index)))))
      
      ;; Refresh ALL buffers
      (dolist (buf (buffer-list))
        (with-current-buffer buf
          (when (derived-mode-p 'prog-mode)
            (my/refresh-overlays-in-buffer)))))))

(defun my/clear-all-highlights ()
  "Clear ALL highlights globally."
  (interactive)
  (setq my/active-highlights-alist nil)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (derived-mode-p 'prog-mode)
        (mapc 'delete-overlay my/buffer-overlays)
        (setq my/buffer-overlays nil))))
  (message "All highlights cleared."))

(defun my/get-search-target ()
  "Helper: Get symbol at point OR the most recent highlighted symbol."
  (or (thing-at-point 'symbol t)
      (caar my/active-highlights-alist)))

(defun my/search-next-symbol ()
  "Jump to next occurrence of symbol at point (or recent highlight)."
  (interactive)
  (let ((symbol (my/get-search-target)))
    (if symbol
        (search-forward-regexp (concat "\\_<" (regexp-quote symbol) "\\_>") nil t)
      (message "No symbol at point or active highlight."))))

(defun my/search-prev-symbol ()
  "Jump to previous occurrence of symbol at point (or recent highlight)."
  (interactive)
  (let ((symbol (my/get-search-target)))
    (if symbol
        (search-backward-regexp (concat "\\_<" (regexp-quote symbol) "\\_>") nil t)
      (message "No symbol at point or active highlight."))))

;; Hooks: Ensure highlights appear when opening new files
(add-hook 'find-file-hook
          (lambda ()
            (when (derived-mode-p 'prog-mode)
              (my/refresh-overlays-in-buffer))))

;; Keybindings
(global-set-key (kbd "M-i") 'my/toggle-highlight-at-point) ; Alt+i: Toggle Highlight
(global-set-key (kbd "M-C") 'my/clear-all-highlights)      ; Alt+Shift+c: Clear All
(global-set-key (kbd "M-n") 'my/search-next-symbol)        ; Alt+n: Next occurrence
(global-set-key (kbd "M-p") 'my/search-prev-symbol)        ; Alt+p: Prev occurrence

;; 5. Dumb Jump (Go to Definition) - Fallback
(use-package dumb-jump
  :ensure t
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :config
  (setq xref-show-definitions-function #'xref-show-definitions-buffer-at-bottom))

;; 6. SystemVerilog LSP (Precise Navigation)
;; Requires external server: 'verible-verilog-ls' (Recommended) or 'svls'
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(verilog-mode . "verilog"))
  (add-to-list 'lsp-language-id-configuration '(verilog-ts-mode . "verilog"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "verible-verilog-ls")
                    :major-modes '(verilog-mode verilog-ts-mode)
                    :priority -1
                    :server-id 'verible-ls)))

(add-hook 'verilog-mode-hook #'lsp-deferred)
(add-hook 'verilog-ts-mode-hook #'lsp-deferred)

;; 7. Code Folding (Hideshow)
(use-package hideshow
  :ensure nil
  :hook (prog-mode . hs-minor-mode)
  :bind (:map prog-mode-map
              ("C-c <tab>" . hs-toggle-hiding)
              ("C-c +" . hs-show-all)
              ("C-c -" . hs-hide-all))
  :config
  (setq hs-isearch-open t)

  (with-eval-after-load 'verilog-mode
    (add-to-list 'hs-special-modes-alist
                 '(verilog-mode
                   "\\b\\(begin\\|case\\|class\\|covergroup\\|fork\\|function\\|generate\\|interface\\|module\\|package\\|program\\|property\\|sequence\\|task\\|uvm_component\\|uvm_object\\)\\b"
                   "\\b\\(end\\|endcase\\|endclass\\|endgroup\\|join\\|join_any\\|join_none\\|endfunction\\|endgenerate\\|endinterface\\|endmodule\\|endpackage\\|endprogram\\|endproperty\\|endsequence\\|endtask\\)\\b"
                   nil
                   verilog-forward-sexp-function))))

(provide 'init-dev)
;;; init-dev.el ends here
