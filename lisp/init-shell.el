;;; init-shell.el --- Shell scripting (Bash & CSH/TCSH) -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------
;; Shell Script Mode (sh-mode)
;; ----------------------------------------------------------------------
;; Emacs 原生 sh-mode 能自动识别 .csh / .tcsh 变体，但不为 CSH/TCSH 提供
;; 任何自动缩进（"No indentation for this shell type"），导致粘贴或换行时
;; 缩进混乱。本模块注入一个轻量、可靠的纯 Elisp CSH 缩进引擎。

(use-package sh-script
  :ensure nil
  :mode ("\\.csh\\'" "\\.tcsh\\'" "\\.sh\\'" "\\.bash\\'")
  :config
  (setq sh-basic-offset 4)
  (setq sh-indentation 4))

(defconst my/csh-open-re
  "\\(foreach\\b\\|if\\b.*then[ \t]*$\\|while\\b.*(\\|switch\\b.*(\\|^else\\b\\)"
  "Regexp matching a CSH line that opens an indented block.")

(defconst my/csh-close-re
  "^\\(endif\\|endforeach\\|endsw\\|endwhile\\|end\\b\\|else\\b\\)"
  "Regexp matching a CSH line that closes an indented block.")

(defun my/csh-indent-line ()
  "Indent the current CSH/TCSH line."
  (interactive)
  (let* ((bol (line-beginning-position))
         (line (string-trim (buffer-substring-no-properties
                             bol (line-end-position))))
         (paren (car (syntax-ppss bol)))
         (indent 0)
         (enclosing nil))
    ;; Find the innermost enclosing block opener (skipping nested blocks).
    (save-excursion
      (goto-char bol)
      (let ((depth 0))
        (while (and (not enclosing) (zerop (forward-line -1)))
          (let ((text (string-trim
                       (buffer-substring-no-properties
                        (line-beginning-position) (line-end-position)))))
            (unless (or (string-empty-p text)
                        (string-prefix-p "#" text))
              (cond
               ((string-match-p my/csh-close-re text)
                (setq depth (1+ depth)))
               ((string-match-p my/csh-open-re text)
                (if (> depth 0)
                    (setq depth (1- depth))
                  (setq enclosing (current-indentation))))))))))
    (cond
     ;; Closing keywords align with their opener.
     ((string-match-p my/csh-close-re line)
      (setq indent (or enclosing 0)))
     ;; Continuation inside parentheses (arrays).
     ((> paren 0)
      (setq indent (* (if (string-prefix-p ")" line) (1- paren) paren)
                    sh-basic-offset)))
     ;; Regular statement inside a block: one extra level.
     (enclosing
      (setq indent (+ enclosing sh-basic-offset)))
     ;; Top-level statement.
     (t
      (setq indent 0)))
    (save-excursion
      (goto-char bol)
      (delete-horizontal-space)
      (indent-to indent))
    (when (< (point) (+ bol indent))
      (goto-char (+ bol indent)))))

(defun my/sh-mode-setup ()
  "Hook for shell scripts: CSH custom indentation and spaces."
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (when (or (and buffer-file-name
                 (string-match "\\.[tc]*csh\\(rc\\)?\\'" buffer-file-name))
            (save-excursion
              (goto-char (point-min))
              (looking-at-p "#!.*\\(t\\|c\\)?csh")))
    ;; NO-QUERY=t, INSERT-FLAG=nil：只设置语法类型，绝不改写文件首行 shebang
    (sh-set-shell "csh" t nil)
    (setq-local indent-line-function #'my/csh-indent-line)
    (electric-indent-local-mode 1)))

(add-hook 'sh-mode-hook #'my/sh-mode-setup)

(provide 'init-shell)
;;; init-shell.el ends here
