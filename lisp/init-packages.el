;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Package Management Configuration (Official Sources)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; 1. Repository Configuration
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(unless (featurep 'init-offline)
  (setq package-archives
        '(("gnu"    . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")
          ("melpa"  . "https://melpa.org/packages/"))))

;; 2. Performance & Security Settings
(setq package-check-signature nil) ;; Faster, avoids GPG issues in some envs
(setq url-queue-timeout 30)

;; 3. Initialization
(package-initialize)

;; 4. Offline Activation (Handles manually copied elpa directory)
(when (featurep 'init-offline)
  (let ((default-directory package-user-dir))
    (when (file-directory-p default-directory)
      (normal-top-level-add-subdirs-to-load-path)
      ;; Force load all -autoloads.el files to ensure commands are defined
      (dolist (dir (directory-files package-user-dir t "^[^.]"))
        (when (file-directory-p dir)
          (let ((autoloads (directory-files dir t "-autoloads.el$")))
            (dolist (file autoloads) (load file t)))))))
  (unless package-activated-list
    (package-activate-all)))

;; 5. Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (unless (locate-library "use-package")
    (if (featurep 'init-offline)
        (warn "Critical: use-package is missing in offline mode.")
      (progn
        (message "Installing use-package...")
        (unless package-archive-contents (package-refresh-contents))
        (package-install 'use-package)))))

;; 6. Global use-package defaults
(require 'use-package)
;; Ensure packages are pre-installed in offline mode
(setq use-package-always-ensure (not (featurep 'init-offline)))

;; 7. Auto Update (Online only)
(unless (featurep 'init-offline)
  (use-package auto-package-update
    :ensure t
    :config
    (setq auto-package-update-delete-old-versions t)
    (setq auto-package-update-hide-results t)))

(provide 'init-packages)
;;; init-packages.el ends here
