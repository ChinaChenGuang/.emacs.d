;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; LaTeX Development (AUCTeX + RefTeX + CDLaTeX)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package auctex
  :ensure t
  :mode ("\\.tex\\'" . latex-mode)
  :config
  ;; 1. Core Settings
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil) ;; Ask for master file
  
  ;; 2. Modern LaTeX Features
  (setq TeX-PDF-mode t)
  (setq TeX-engine 'xelatex) ;; Default to xelatex for better font support
  
  ;; 3. Interaction & View
  ;; If pdf-tools is installed, use it. Otherwise, fallback to system viewer.
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")
                                     (output-pdf "Evince")
                                     (output-pdf "Zathura")
                                     (output-pdf "Okular")))
                                     
  ;; 4. Hooks
  (add-hook 'LaTeX-mode-hook (lambda ()
                               (outline-minor-mode 1)
                               (turn-on-reftex)
                               (setq reftex-plug-into-AUCTeX t))))

;; RefTeX: Citation and Cross-reference management
(use-package reftex
  :ensure t
  :defer t
  :config
  (setq reftex-cite-format 'biblatex))

;; CDLaTeX: Fast math symbol and structural typing
(use-package cdlatex
  :ensure t
  :defer t
  :hook (LaTeX-mode . turn-on-cdlatex))

;; Company-AUCTeX: Integration with Company
(use-package company-auctex
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-auctex-labels)
    (add-to-list 'company-backends 'company-auctex-bibs)
    (add-to-list 'company-backends 'company-auctex-macros)
    (add-to-list 'company-backends 'company-auctex-environments)))

(provide 'init-latex)
;;; init-latex.el ends here
