;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Package Management Configuration (Official Sources)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; 1. Package Repositories (Official)
(unless (featurep 'init-offline)
  (setq package-archives
        '(("gnu"    . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa"  . "https://melpa.org/packages/"))))

;; (setq package-archives
;;      '(("melpa" . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/melpa/")
;;        ("org"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/org/")
;;        ("gnu"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/gnu/")))

;; 2. Stability Settings
;; On Windows, GPG signature verification can sometimes fail even with official sources.
;; Keeping this disabled ensures smoother installation.
(setq package-check-signature nil)
(setq url-queue-timeout 30)
;; 3. Initialize Package System
(package-initialize)

;; 4. Bootstrap `use-package`
;; Add compat path to load-path for manual use-package bundle
(let ((compat-path (expand-file-name "lisp/compat" user-emacs-directory)))
  (when (file-directory-p compat-path)
    (add-to-list 'load-path compat-path)))

(unless (package-installed-p 'use-package)
  (if (or (featurep 'init-offline) 
          (not (bound-and-true-p package-archives)))
      (unless (locate-library "use-package")
        (warn "Warning: use-package not installed, not in compat folder, and we are offline."))
    (message "Installing use-package...")
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))

;; 5. Configure `use-package`
(require 'use-package)

;; Always ensure packages are installed by default (unless offline).
(setq use-package-always-ensure (not (featurep 'init-offline)))


;; 6. Auto Update
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t))

(provide 'init-packages)
;;; init-packages.el ends here
