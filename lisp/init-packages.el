;;; -*- lexical-binding: t -*-
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

;; 2.5 Compatibility Layer (compat, use-package polyfills for cross-version support)
(let ((compat-elpa (car (file-expand-wildcards (expand-file-name "elpa/compat-*" user-emacs-directory))))
      (compat-bundled (expand-file-name "lisp/compat" user-emacs-directory)))
  (when (and compat-elpa (file-directory-p compat-elpa))
    (add-to-list 'load-path compat-elpa))
  (when (file-directory-p compat-bundled)
    (add-to-list 'load-path compat-bundled)))
(require 'compat nil t)
(when (< emacs-major-version 31)
  (require 'compat-31 nil t))

;; 3. Initialization (Fast Package Quickstart)
(setq package-quickstart t)
(setq package-quickstart-file (expand-file-name "package-quickstart.el" user-emacs-directory))
(package-initialize)

;; 4. Offline Activation (Handles manually copied elpa directory)
(when (featurep 'init-offline)
  (unless package--quickstart-pkgs
    (let ((default-directory package-user-dir))
      (when (file-directory-p default-directory)
        (normal-top-level-add-subdirs-to-load-path)))
    (unless package-activated-list
      (package-activate-all))))

(defun my/package-quickstart-rebuild ()
  "重新生成 package-quickstart.el，将所有包索引预编译为单一文件，大幅压缩启动时间。"
  (interactive)
  (package-quickstart-refresh)
  (message "✅ package-quickstart.el 索引已重新生成！"))

;; 5. Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (unless (locate-library "use-package")
    (if (featurep 'init-offline)
        (warn "Critical: use-package is missing in offline mode.")
      (progn
        (message "Installing use-package...")
        ;; Removed automatic package-refresh-contents to prevent network hangs
        (package-install 'use-package)))))

;; 6. Global use-package defaults
(require 'use-package)
;; 无论在线离线，启动时绝对不自动去外网下载缺失的包，防止网络卡死
(setq use-package-always-ensure nil)

(provide 'init-packages)
;;; init-packages.el ends here
