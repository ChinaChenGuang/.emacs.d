;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Dashboard Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  ;; Set the title
  (setq dashboard-banner-logo-title "Welcome to Emacs")
  ;; Set the banner (official logo)
  (setq dashboard-startup-banner 'official)
  ;; Content to display
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)))
  ;; Center the content
  (setq dashboard-center-content t)
  ;; Use Nerd Icons
  (setq dashboard-display-icons-p t) 
  (setq dashboard-icon-type 'nerd-icons) 
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t))

(provide 'init-dashboard)
