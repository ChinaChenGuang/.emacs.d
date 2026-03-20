;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SystemC Development Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'init-cpp)

;; 1. File Associations
;; Prefer Treesit modes if available
(if (and (fboundp 'treesit-available-p) (treesit-available-p))
    (progn
      (add-to-list 'auto-mode-alist '("\\.sc\\'" . c++-ts-mode))
      (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-ts-mode)))
  (progn
    (add-to-list 'auto-mode-alist '("\\.sc\\'" . c++-mode))
    (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))))

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
(with-eval-after-load 'c++-ts-mode
  (define-key c++-ts-mode-map (kbd "C-c C-s") #'my/systemc-compile-command))
(with-eval-after-load 'cc-mode
  (define-key c++-mode-map (kbd "C-c C-s") #'my/systemc-compile-command))

(provide 'init-systemc)
;;; init-systemc.el ends here
