;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Development Tools
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Magit: The best Git client ever
(use-package magit
  :bind ("C-x g" . magit-status))

;; 2. Flycheck: On-the-fly syntax checking
(use-package flycheck
  :init (global-flycheck-mode))

;; 3. Symbol Overlay (Keyword Highlighting)
;; Highlight all occurrences of the symbol under cursor.
;; Great for tracking signals in Verilog/SystemVerilog.
;; Usage: M-i to toggle highlight, M-n/M-p to jump to next/prev occurrence.
(use-package symbol-overlay
  :ensure t
  :hook (prog-mode . symbol-overlay-mode)
  :bind (:map symbol-overlay-mode-map
              ("M-i" . symbol-overlay-put)      ; Toggle highlight for symbol at point
              ("M-n" . symbol-overlay-jump-next); Jump to next occurrence
              ("M-p" . symbol-overlay-jump-prev); Jump to prev occurrence
              ("M-C" . symbol-overlay-remove-all))) ; Clear all highlights

;; 4. Dumb Jump (Keyword Jump / Go to Definition)
;; "Just works" jump-to-definition without setting up TAGS files.
;; Supports SystemVerilog tasks, functions, classes, and macros.
(use-package dumb-jump
  :ensure t
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :config
  (setq xref-show-definitions-function #'xref-show-definitions-buffer-at-bottom))

;; 5. Code Folding (Hideshow)
;; Enable code folding for all programming modes.
(use-package hideshow
  :ensure nil ; Built-in package
  :hook (prog-mode . hs-minor-mode)
  :bind (:map prog-mode-map
              ("C-c <tab>" . hs-toggle-hiding)  ; Fold/Unfold the block at cursor
              ("C-c +" . hs-show-all)           ; Expand all
              ("C-c -" . hs-hide-all))          ; Collapse all
  :config
  (setq hs-isearch-open t)

  ;; --------------------------------------------------------------------------
  ;; SystemVerilog Specific Folding Rules
  ;; --------------------------------------------------------------------------
  ;; We use 'verilog-forward-sexp-function' to find the EXACT matching end keyword.
  ;; This ensures "Fold Nearest Matching" works correctly for nested blocks.
  (with-eval-after-load 'verilog-mode
    (add-to-list 'hs-special-modes-alist
                 '(verilog-mode
                   ;; Start keywords (Regular Expression)
                   "\\b\\(begin\\|case\\|class\\|covergroup\\|fork\\|function\\|generate\\|interface\\|module\\|package\\|program\\|property\\|sequence\\|task\\|uvm_component\\|uvm_object\\)\\b"
                   ;; End keywords (Regular Expression)
                   "\\b\\(end\\|endcase\\|endclass\\|endgroup\\|join\\|join_any\\|join_none\\|endfunction\\|endgenerate\\|endinterface\\|endmodule\\|endpackage\\|endprogram\\|endproperty\\|endsequence\\|endtask\\)\\b"
                   ;; Comment regex
                   nil
                   ;; Forward function (CRITICAL: Uses Verilog-mode's internal logic to find the matching end)
                   verilog-forward-sexp-function))))

(provide 'init-dev)
;;; init-dev.el ends here
