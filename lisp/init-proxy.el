;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Network Proxy Configuration & Status Monitor
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgroup my-proxy nil
  "Proxy configuration group."
  :group 'external)

(defcustom my-proxy-host "127.0.0.1"
  "Host address for the proxy server."
  :type 'string
  :group 'my-proxy)

(defcustom my-proxy-port "7897"  ;; <--- 请确认您的代理端口
  "HTTP Port for the proxy server."
  :type 'string
  :group 'my-proxy)

;; ----------------------------------------------------------------------------
;; Modeline Display (Status Bar Integration)
;; ----------------------------------------------------------------------------
(defvar my/proxy-mode-line-string " [Proxy: OFF]"
  "String to display in the mode line.")

;; Add our variable to the global mode string list so it shows up in the UI
(unless (member '(:eval my/proxy-mode-line-string) global-mode-string)
  (add-to-list 'global-mode-string '(:eval my/proxy-mode-line-string) t))

(defun my/update-proxy-modeline (status &optional latency)
  "Update the modeline string based on STATUS and LATENCY."
  (setq my/proxy-mode-line-string
        (propertize
         (if latency
             (format " [Proxy: %s | %dms]" status (round (* latency 1000)))
           (format " [Proxy: %s]" status))
         'face (if (string= status "ON")
                   '(:foreground "#A3BE8C" :weight bold) ;; Green for ON
                 '(:foreground "#BF616A" :weight bold))))) ;; Red for OFF

;; ----------------------------------------------------------------------------
;; Proxy Logic
;; ----------------------------------------------------------------------------
(defun my/proxy-http-url ()
  (concat my-proxy-host ":" my-proxy-port))

(defun my/enable-proxy ()
  "Enable HTTP/HTTPS proxy for Emacs and subprocesses."
  (interactive)
  (let ((proxy (my/proxy-http-url)))
    ;; 1. Emacs internal network
    (setq url-proxy-services
          `(("http" . ,proxy)
            ("https" . ,proxy)
            ("no_proxy" . "localhost,127.0.0.1,.local,::1")))
    
    ;; 2. Subprocesses
    (setenv "http_proxy" (concat "http://" proxy))
    (setenv "https_proxy" (concat "http://" proxy))
    (setenv "all_proxy" (concat "socks5://" my-proxy-host ":" my-proxy-port))
    
    (my/update-proxy-modeline "ON")
    (message "Network Proxy ENABLED: %s" proxy)))

(defun my/disable-proxy ()
  "Disable network proxy."
  (interactive)
  (setq url-proxy-services nil)
  (setenv "http_proxy" nil)
  (setenv "https_proxy" nil)
  (setenv "all_proxy" nil)
  
  (my/update-proxy-modeline "OFF")
  (message "Network Proxy DISABLED."))

(defun my/toggle-proxy ()
  "Toggle network proxy settings."
  (interactive)
  (if url-proxy-services
      (my/disable-proxy)
    (my/enable-proxy)))

;; ----------------------------------------------------------------------------
;; Network Speed/Latency Test
;; ----------------------------------------------------------------------------
(defun my/proxy-check-latency ()
  "Check latency to Google and update modeline."
  (interactive)
  (if url-proxy-services
      (let ((url "http://www.google.com/generate_204")
            (start (float-time)))
        (url-retrieve url
                      (lambda (status start-time)
                        (unless (plist-get status :error)
                          (let ((latency (- (float-time) start-time)))
                            (my/update-proxy-modeline "ON" latency)))
                        (kill-buffer (current-buffer)))
                      (list start)))
    (message "Proxy is OFF. Skipping Google latency check.")))

(defun my/proxy-speed-test ()
  "Test connection speed by downloading a small image."
  (interactive)
  (let* ((url (if url-proxy-services
                  "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png"
                "https://mirrors.tuna.tsinghua.edu.cn/static/img/logo-small.png"))
         (start-time (float-time)))
    (message "Testing speed... Downloading from %s" (if url-proxy-services "Google" "Tsinghua"))
    (url-retrieve url
                  (lambda (status start)
                    (let ((end-time (float-time))
                          (size (buffer-size)))
                      (kill-buffer (current-buffer))
                      (if (plist-get status :error)
                          (message "Speed Test Failed: %s" (plist-get status :error))
                        (let* ((duration (- end-time start))
                               (speed-kb (/ (/ size 1024.0) duration)))
                          (message "Download Complete: %.2f KB in %.2fs (Speed: %.2f KB/s)"
                                   (/ size 1024.0) duration speed-kb)
                          ;; Update modeline with latest latency info derived from this test
                          (when url-proxy-services
                             (my/update-proxy-modeline "ON" duration))))))
                  (list start-time))))

;; Bindings
(global-set-key (kbd "C-c x") 'my/toggle-proxy)

;; ----------------------------------------------------------------------------
;; Auto-Enable on Startup
;; ----------------------------------------------------------------------------
(my/enable-proxy)
;; Optionally check latency once on startup (delayed to not block init)
(run-with-timer 5 nil #'my/proxy-check-latency)

(provide 'init-proxy)
;;; init-proxy.el ends here
