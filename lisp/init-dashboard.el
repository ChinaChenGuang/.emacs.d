;;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Dashboard Configuration - Geek Style
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dashboard
  :ensure t
  :config
  ;; 1. Initialize
  (setq inhibit-startup-screen t)
  (dashboard-setup-startup-hook)

  ;; 2. Banner & Title (Minimalist Style)
  (setq dashboard-startup-banner 'logo) ; 使用文字 Logo
  
  ;; 标题改为简洁风格
  (setq dashboard-banner-logo-title "Emacs :: Minimalist Workspace")

  ;; 3. Content & Layout
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-show-shortcuts t)            ; 显示快捷键提示
  
  (setq dashboard-items '((recents  . 10)
                          (projects . 5)
                          (bookmarks . 5)))

  ;; 4. Icons (Aesthetics)
  (setq dashboard-display-icons-p t) 
  (setq dashboard-icon-type 'nerd-icons) 
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)

  ;; 5. Info & Footer
  (setq dashboard-set-init-info t)            ; Show "Loaded in X.XX seconds"
  
  ;; Random geeky quotes in the footer
  (setq dashboard-footer-messages '("Happy Hacking!"
                                    "M-x butterfly"
                                    "Escape Meta Alt Control Shift"
                                    "The One True Editor"))
  (setq dashboard-footer-icon (nerd-icons-octicon "nf-oct-terminal" :height 1.1 :v-adjust 0.0 :face 'dashboard-footer-icon-face))

  ;; 6. Navigator Buttons (Quick Actions)
  ;; Adds clickable buttons under the logo for common tasks
  (setq dashboard-set-navigator t)
  (setq dashboard-navigator-buttons
        `(;; Line 1
          ((,(nerd-icons-octicon "nf-oct-gear" :height 1.1 :v-adjust 0.0)
            "Config"
            "Open init.el"
            (lambda (&rest _) (find-file user-init-file)))

           (,(nerd-icons-octicon "nf-oct-package" :height 1.1 :v-adjust 0.0)
            "Updates"
            "Open Package Manager"
            (lambda (&rest _) (package-list-packages)))

           (,(nerd-icons-octicon "nf-oct-rocket" :height 1.1 :v-adjust 0.0)
            "Scratch"
            "Switch to Scratch buffer"
            (lambda (&rest _) (switch-to-buffer "*scratch*")))))))

(provide 'init-dashboard)
;;; init-dashboard.el ends here
