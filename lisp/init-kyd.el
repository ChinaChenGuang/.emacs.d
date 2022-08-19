;;***************************************************************************************************
;; Require Plugins File
;;***************************************************************************************************
(require 'move-line-up-down)
(require 'window-numbering)


;;***************************************************************************************************
;; Config Emcas Custom key
;;***************************************************************************************************
(defalias 'yes-or-no-p' 'y-or-n-p)
(cua-mode t)
(global-set-key (kbd "C-x C-g") 'goto-line)
(window-numbering-mode 1)

;;***************************************************************************************************
;; Config Emcas Exchange Line 
;;***************************************************************************************************

;;(global-set-key (kbd "<left>") 'window-left)
;;(global-set-key (kbd "<up>") 'window-up)
;;(global-set-key (kbd "<down>") 'window-down)
;;(global-set-key (kbd "<right>") 'window-right)


(provide 'init-kyd)
