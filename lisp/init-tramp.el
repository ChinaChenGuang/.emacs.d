;;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; TRAMP Configuration (Remote File Editing via SSH)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tramp
  :ensure nil ; Built-in, no need to download
  :defer t
  :config
  ;; 1. Core Settings
  ;; Use sshx on Windows to avoid native ssh.exe PTY allocation hangs
  (setq tramp-default-method (if (eq system-type 'windows-nt) "sshx" "ssh"))
  
  ;; 2. Performance Optimizations for SSH
  ;; Enable SSH ControlMaster multiplexing (drastically reduces connection overhead)
  ;; Note: Windows native SSH does NOT support Unix domain sockets for ControlMaster!
  (setq tramp-use-ssh-controlmaster-options (not (eq system-type 'windows-nt)))
  
  ;; Keep auto-save and backup files locally instead of on the remote machine
  (setq tramp-auto-save-directory (expand-file-name "tmp/tramp/" user-emacs-directory))
  
  ;; Disable file locks (the .#filename files) for remote files to reduce latency
  (setq remote-file-name-inhibit-locks t)
  
  ;; Speed up chunk size for large files over SSH
  (setq tramp-chunksize 8192)
  
  ;; Disable VC (Version Control) for remote files. 
  ;; Git/SVN checks over SSH are the #1 cause of TRAMP slowdowns.
  (with-eval-after-load 'vc
    (setq vc-ignore-dir-regexp
          (format "\\(%s\\)\\|\\(%s\\)"
                  vc-ignore-dir-regexp
                  tramp-file-name-regexp))))

;; 3. Simple Operation
(defun my/find-remote-file ()
  "Quickly connect to a remote server via SSH."
  (interactive)
  (let* ((host (read-string "🌐 SSH 目标 (格式: user@server): "))
         (path (read-string "📂 远程路径 (默认 ~): " "~"))
         (method (if (eq system-type 'windows-nt) "sshx" "ssh")))
    (find-file (format "/%s:%s:%s" method host path))))

;; 绑定快捷键 C-c r (Remote)
(global-set-key (kbd "C-c r") 'my/find-remote-file)

(provide 'init-tramp)
;;; init-tramp.el ends here
