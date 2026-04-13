;;; init-perl.el --- Absolute Basic Perl support -*- lexical-binding: t -*-

;; 1. 关联文件后缀到正确的函数 cperl-mode (优于默认的 perl-mode)
(add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.t\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.perl\\'" . cperl-mode))

;; 2. 基础配置
(with-eval-after-load 'cperl-mode
  (setq cperl-indent-level 4)
  ;; 禁用 cperl 自带的 "智能" 符号补全，避免与 smartparens 冲突产生双括号
  (setq cperl-electric-parens nil)
  (setq cperl-electric-lbrace-space nil)
  (setq cperl-electric-linefeed nil)
  
  ;; 确保基本的括号键只执行基本的自插入，交给 smartparens 处理
  (let ((map cperl-mode-map))
    (define-key map (kbd "{") 'self-insert-command)
    (define-key map (kbd "(") 'self-insert-command)
    (define-key map (kbd "[") 'self-insert-command)))

(with-eval-after-load 'perl-mode
  (setq perl-indent-level 4)
  (setq perl-electric-lbrace nil)
  (let ((map perl-mode-map))
    (define-key map (kbd "{") 'self-insert-command)
    (define-key map (kbd "(") 'self-insert-command)
    (define-key map (kbd "[") 'self-insert-command)))

(provide 'init-perl)
;;; init-perl.el ends here
