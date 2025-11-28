;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Dashboard Configuration - Geek Style
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dashboard
  :ensure t
  :config
  ;; 1. Initialize
  (dashboard-setup-startup-hook)

  ;; 2. Banner & Title (The "Geek" Look)
  ;; Use a built-in ASCII logo (2 or 3 are great choices for text art)
  ;; 2 = Classic Emacs logo in text
  ;; 3 = GNU logo in text
  (setq dashboard-startup-banner 2)
  
  ;; A cool status message instead of "Welcome"
  (setq dashboard-banner-logo-title "[ SYSTEM ONLINE :: WAITING FOR INPUT ]")

  ;; 3. Content & Layout
  (setq dashboard-center-content t)           ; Center horizontally
  (setq dashboard-vertically-center-content t); Center vertically (like a screensaver)
  
  (setq dashboard-items '((recents  . 8)      ; Show 8 recent files
                          (projects . 5)      ; Show 5 recent projects
                          (bookmarks . 3)))   ; Show 3 bookmarks

  ;; 4. Icons (Requires Nerd Fonts)
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
