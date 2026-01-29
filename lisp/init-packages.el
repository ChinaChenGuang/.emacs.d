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

;; Ensure we have the archive contents
(unless (or (featurep 'init-offline) package-archive-contents)
  (message "Refreshing package contents...")
  (package-refresh-contents))

;; 4. Bootstrap `use-package`
(unless (or (featurep 'init-offline) (package-installed-p 'use-package))
  (message "Refreshing package contents...")
  (package-refresh-contents)
  (message "Installing use-package...")
  (package-install 'use-package))

;; 5. Configure `use-package`
(eval-when-compile
  (require 'use-package))

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
