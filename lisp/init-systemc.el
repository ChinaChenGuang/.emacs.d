;;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SystemC Development Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'init-cpp)

;; 1. File Associations
(add-to-list 'auto-mode-alist '("\\.sc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; 2. SystemC Compilation Helper
(defun my/systemc-compile-command ()
  "Compile the current SystemC file with -lsystemc."
  (interactive)
  (let ((file (file-name-nondirectory buffer-file-name)))
    (setq-local compile-command
                (format "g++ -g -Wall -Wextra %s -o %s -lsystemc"
                        file
                        (file-name-sans-extension file)))
    (compile compile-command)))

;; 3. Keybindings for SystemC
(with-eval-after-load 'cc-mode
  (define-key c++-mode-map (kbd "C-c C-s") #'my/systemc-compile-command))

(provide 'init-systemc)
;;; init-systemc.el ends here
