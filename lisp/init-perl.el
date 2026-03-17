;;; init-perl.el --- Absolute Basic Perl support -*- lexical-binding: t -*-

;; 1. 关联文件后缀到正确的函数 cperl-mode (优于默认的 perl-mode)
(add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.t\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.perl\\'" . cperl-mode))

;; 2. 基础配置
(with-eval-after-load 'cperl-mode
  (setq cperl-indent-level 4))

(provide 'init-perl)
;;; init-perl.el ends here
