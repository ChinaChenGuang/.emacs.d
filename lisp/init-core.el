;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Core System Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Encoding
;; Set UTF-8 as the default encoding system for everything.
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; 2. File Management
;; Auto-revert buffers when files change on disk.
(global-auto-revert-mode t)

;; Disable lockfiles (those .#filename files)
(setq create-lockfiles nil)

;; 3. Backup Management
;; Store all backup files in a centralized directory instead of cluttering project folders.
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(setq make-backup-files t       ; Enable backups
      version-control t         ; Use version numbers for backups
      backup-by-copying t       ; Copy instead of renaming
      delete-old-versions t     ; Delete old versions silently
      kept-old-versions 6       ; Keep 6 oldest versions
      kept-new-versions 9)      ; Keep 9 newest versions

;; 4. User Experience
;; Answer "y" or "n" instead of "yes" or "no".
(fset 'yes-or-no-p 'y-or-n-p)

(provide 'init-core)
