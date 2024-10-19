;; theme

;;***************************************************************************************************
;; Config Emcas DISPLAY
;;***************************************************************************************************
;; (global-linum-mode t)
(global-display-line-numbers-mode)
(global-hl-line-mode t)

;;***************************************************************************************************
;; Config Emcas Theme
;;***************************************************************************************************


;;(use-package gruvbox-theme
;;  :init (load-theme 'gruvbox-dark-soft t))
(load-theme 'high-contrast t)
;;***************************************************************************************************
;; Config Emcas Windows
;;***************************************************************************************************
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;***************************************************************************************************
;; Config Emcas fontface
;;***************************************************************************************************

;;***************************************************************************************************
;; Config Emcas fontface
;;***************************************************************************************************
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda()
    (highlight-parentheses-mode)))
(global-highlight-parentheses-mode t)

(set-frame-font "-outline-Courier New-normal-normal-normal-mono-20-*-*-*-c-*-iso8859-1")

;;***************************************************************************************************
;; Line Hightlight theme config
;;***************************************************************************************************
(set-face-attribute 'hl-line nil :background "gray15")
(set-cursor-color "#FFA500")
(setq-default cursor-type 'bar)

(provide 'init-ui)

