;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SystemC Development Configuration
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'init-cpp)

;; 1. File Associations
;; Treat .sc and .cpp files in SystemC projects as C++
(add-to-list 'auto-mode-alist '("\.sc\'" . c++-ts-mode))
(add-to-list 'auto-mode-alist '("\.h\'" . c++-ts-mode))

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
;; Bind C-c C-s to SystemC compile in C++ modes
(with-eval-after-load 'c++-ts-mode
  (define-key c++-ts-mode-map (kbd "C-c C-s") #'my/systemc-compile-command))

;; 4. LSP/Clangd Configuration for SystemC
;; Clangd usually finds system libraries automatically.
;; If your SystemC is installed in a non-standard location (e.g., /opt/systemc),
;; you might need to create a .clangd file or compile_commands.json.

(provide 'init-systemc)
;;; init-systemc.el ends here
