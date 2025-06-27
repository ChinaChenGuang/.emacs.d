;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; 鍏朵粬鎻掍欢閰嶇疆 (Miscellaneous Packages)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package neotree
  :bind ("<f8>" . neotree-toggle))

(use-package window-numbering
  :hook (after-init . window-numbering-mode))

(use-package avy
  :bind (("C-;" . avy-goto-char-timer)
         ("M-g g" . avy-goto-line)))

;; 浣跨敤 symbol-overlay 鏇挎崲鏃х殑 symbol-highlight
;; 瀹冧細鍦ㄥ厜鏍囧仠鐣欐椂鑷姩楂樹寒鍚屽悕绗﹀彿
(use-package symbol-overlay
  :ensure t
  :hook (prog-mode . symbol-overlay-mode)
  :config
  (define-key symbol-overlay-mode-map (kbd "M-n") #'symbol-overlay-jump-next)
  (define-key symbol-overlay-mode-map (kbd "M-p") #'symbol-overlay-jump-prev))

;; 新增 Obsidian 配置

(use-package obsidian
  :ensure t ; 确保 use-package 会自动安装它
  :config
  ;; !!! 重要：请将这里的路径修改为您自己 Obsidian 笔记库的实际路径 !!!
  (setq obsidian-vault-path "~/Documents/ObsidianVault")

  ;; 设置快捷键, C-c n 为前缀 (n for notes)
  (define-key obsidian-mode-map (kbd "C-c n n") #'obsidian-new-note)       ; 新建笔记
  (define-key obsidian-mode-map (kbd "C-c n f") #'counsel-obsidian)        ; 查找笔记 (使用 Counsel)
  (define-key obsidian-mode-map (kbd "C-c n s") #'obsidian-search-text)    ; 全文搜索
  (define-key obsidian-mode-map (kbd "C-c n b") #'obsidian-list-backlinks) ; 列出反向链接
  )

(provide 'init-misc)
;;; init-misc.el ends here
