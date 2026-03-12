;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Version Compatibility Layer (Backports & Polyfills)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Path Configuration for Bundled Compatibility Libraries
(let ((compat-path (expand-file-name "lisp/compat" user-emacs-directory)))
  (when (file-directory-p compat-path)
    (add-to-list 'load-path compat-path)
    
    ;; A. Load 'compat' library (Essential for modern packages on Emacs < 30)
    (require 'compat nil t)
    
    ;; B. Load 'use-package' (Built-in since 29.1)
    (unless (fboundp 'use-package)
      (require 'use-package nil t))
      
    ;; C. Load 'which-key' (Built-in since 30.1)
    (unless (fboundp 'which-key-mode)
      (require 'which-key nil t))))

;; 2. Tree-sitter Compatibility (Emacs 29+)
;; Define stubs or redirects for older versions to prevent breaking init-treesit.el
(unless (fboundp 'treesit-available-p)
  (defun treesit-available-p () nil)
  (defun treesit-ready-p (&rest _args) nil))

;; 3. Emoji/Font Compatibility (Emacs 28+)
;; 'emoji script-tag was introduced in 28.1
(unless (boundp 'char-script-table)
  (setq char-script-table (make-char-table 'char-script-table)))

;; 4. Directory & OS Specific Tweaks
(when (eq system-type 'windows-nt)
  ;; Windows specific path fixes if any
  )

(provide 'init-compat)
