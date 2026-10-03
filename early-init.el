;;; -*- lexical-binding: t -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Early Initialization - Performance & UI Flicker Prevention
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Garbage Collection Optimization during startup
;; Set GC threshold to maximum during startup to completely eliminate GC pauses.
;; It will be reset to a sane default in `init.el` after startup completes.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; 2. File Name Handler Optimization
;; Emacs checks every loaded file against `file-name-handler-alist` regexes.
;; Disabling it during startup dramatically speeds up startup, especially on NFS / remote servers.
(defvar my/saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; 3. UI Pre-loading & Flicker/Resize Prevention
;; Disable GUI elements early to prevent "white flash" and UI resizing flicker.
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)

;; 4. Package Management
;; Prevent package.el from initializing automatically. We handle it
;; explicitly in `init-packages.el` to ensure correct loading order.
(setq package-enable-at-startup nil
      package-quickstart t)
