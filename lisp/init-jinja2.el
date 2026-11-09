;;; init-jinja2.el --- Jinja2 template support -*- lexical-binding: t -*-

;; ----------------------------------------------------------------------
;; Jinja2 Mode Configuration
;; - 文件关联: .jinja2, .j2, .jinja, 以及 *.html.j2 等
;; - 缩进规范: 默认 2 空格缩进，禁用 Tabs
;; - Smartparens 自动配对: {% %}, {{ }}, {# #}
;; - 快捷键:
;;   C-c c : 自动闭合标签 (jinja2-close-tag)
;;   C-c t : 插入逻辑标签 {%  %} (jinja2-insert-tag)
;;   C-c v : 插入变量标签 {{  }} (jinja2-insert-var)
;;   C-c # : 插入注释标签 {#  #} (jinja2-insert-comment)
;; ----------------------------------------------------------------------

(use-package jinja2-mode
  :ensure nil
  :mode (("\\.jinja2\\'" . jinja2-mode)
         ("\\.j2\\'"     . jinja2-mode)
         ("\\.jinja\\'"  . jinja2-mode))
  :hook ((jinja2-mode . (lambda ()
                          (setq-local indent-tabs-mode nil)
                          (setq-local tab-width 2)
                          (setq-local sgml-basic-offset 2)))
         (jinja2-mode . smartparens-mode))
  :config
  ;; Smartparens 自动成对闭合与空格处理增强
  (with-eval-after-load 'smartparens
    (sp-with-modes 'jinja2-mode
      (sp-local-pair "{%" "%}" :post-handlers '(("| " "SPC")))
      (sp-local-pair "{{" "}}" :post-handlers '(("| " "SPC")))
      (sp-local-pair "{#" "#}" :post-handlers '(("| " "SPC"))))))

(provide 'init-jinja2)
;;; init-jinja2.el ends here
