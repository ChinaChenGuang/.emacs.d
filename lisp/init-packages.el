;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Package Management Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; 1. Package Repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; 2. Initialize Package System
(package-initialize)

;; 3. Bootstrap `use-package`
;; If use-package is not installed, refresh contents and install it.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; 4. Configure `use-package`
(eval-when-compile
  (require 'use-package))

;; Always ensure packages are installed by default.
;; This saves us from adding :ensure t to every package declaration.
(setq use-package-always-ensure t)

(provide 'init-packages)
