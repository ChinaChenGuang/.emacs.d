;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Early Initialization - Performance & UI Flicker Prevention
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Garbage Collection Optimization during startup
;; Increase the GC threshold to 100MB to prevent GC from running during startup.
;; It will be reset to a sane default in `init.el` after startup is complete.
(setq gc-cons-threshold (* 100 1024 1024))

;; 2. UI Pre-loading
;; Disable GUI elements early to prevent "white flash" and UI resizing flicker.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; 3. Package Management
;; Prevent package.el from initializing automatically. We will handle it
;; explicitly in `init-packages.el` to ensure correct loading order.
(setq package-enable-at-startup nil)
