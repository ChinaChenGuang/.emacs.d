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

(provide 'init-dev)
