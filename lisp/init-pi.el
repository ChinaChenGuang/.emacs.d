;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; AI Assistants: Pi Coding Agent & GPTel (Writing)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Pi Coding Agent (Requires 'pi' CLI installed on system)


(use-package pi-coding-agent
  :ensure t
  :bind (("C-c p p" . pi-coding-agent)
         ("C-c p r" . pi-coding-agent-rewrite-region))
  :init
  (defalias 'pi 'pi-coding-agent))

;; 2. GPTel: The versatile LLM client for Org-mode Writing
(use-package gptel
  :ensure t
  :bind (("C-c q q" . gptel-send)          ; 原地发送/对话
         ("C-c q m" . gptel-menu)          ; 设置菜单
         ("C-c q s" . gptel-rewrite))      ; 润色/重写
  :config
  ;; --- 官方 DeepSeek 配置 ---
  (gptel-make-openai "DeepSeek"
    :host "api.deepseek.com"
    :endpoint "/chat/completions"
    :stream t
    :key (bound-and-true-p my-deepseek-api-key)
    :models '(deepseek-v4-flash deepseek-v4-pro))

  ;; ;; --- OpenRouter 备选 (保留用于访问其他模型) ---
  ;; (gptel-make-openai "OpenRouter"
  ;;   :host "openrouter.ai"
  ;;   :endpoint "/api/v1/chat/completions"
  ;;   :stream t
  ;;   :key "YOUR_OPENROUTER_API_KEY"
  ;;   :models '(inflection/inflection-3-pi
  ;;             anthropic/claude-3.5-sonnet))

  ;; 默认设置
  (setq-default gptel-model 'deepseek-chat
                gptel-backend (gptel-get-backend "DeepSeek")))

;; 3. GPTel-Aibo: The Chat Sidebar/UI for GPTel
(use-package gptel-aibo
  :ensure t
  :bind (("C-c q a" . gptel-aibo))         ; 开启聊天侧边栏
  :config
  (setq gptel-aibo-display-buffer-action
        '((display-buffer-in-side-window)
          (side . right)
          (window-width . 0.3))))

(provide 'init-pi)
