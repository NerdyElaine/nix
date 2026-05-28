;;; snippet.el --- Description -*- lexical-binding: t; -*-
;;; snippet.el --- Snippet and completion configuration -*- lexical-binding: t; -*-

;;
;;; Packages

(use-package yasnippet
  :straight t
  :ensure t
  :hook ((LaTeX-mode . yas-minor-mode)
         (org-mode   . yas-minor-mode)
         (prog-mode  . yas-minor-mode))
  :init
  (defvar yas-verbosity 2)
  :config
  (yas-reload-all)

  ;; Map tree-sitter modes to their parent snippet tables
  (dolist (mapping '((python-ts-mode     . python-mode)
                     (js-ts-mode         . js-mode)
                     (tsx-ts-mode        . js-mode)
                     (typescript-ts-mode . typescript-mode)
                     (css-ts-mode        . css-mode)
                     (c-ts-mode          . c-mode)
                     (c++-ts-mode        . c++-mode)
                     (rust-ts-mode       . rust-mode)
                     (go-ts-mode         . go-mode)
                     (bash-ts-mode       . sh-mode)
                     (nix-ts-mode        . conf-mode)))
    (add-hook (intern (concat (symbol-name (car mapping)) "-hook"))
              (let ((parent (cdr mapping)))
                (lambda () (yas-activate-extra-mode parent)))))

  ;; HACK: Suppress prompting when snippets are expanded for completion or
  ;;   documentation popups (from corfu, company, etc).
  (defun +corfu--suppress-prompts-during-completion-a (fn &rest args)
    (let ((yas-prompt-functions '(yas-no-prompt))
          (non-essential t))
      (apply fn args)))
  (advice-add #'yasnippet-capf--doc-buffer :around #'+corfu--suppress-prompts-during-completion-a)
  (advice-add #'company-yasnippet--doc     :around #'+corfu--suppress-prompts-during-completion-a)

  ;; Fix: `yas--all-templates' sometimes returns duplicates
  (defun +snippets--remove-duplicates-a (templates)
    (cl-delete-duplicates templates :test #'equal))
  (advice-add #'yas--all-templates :filter-return #'+snippets--remove-duplicates-a)

  ;; Tell smartparens overlays not to interfere with yasnippet keybinds
  (with-eval-after-load 'smartparens
    (advice-add #'yas-expand :before #'sp-remove-active-pair-overlay))

  ;; HACK: Smartparens interferes with snippets expanded by `hippie-expand',
  ;;   so temporarily disable it during snippet expansion.
  (with-eval-after-load 'hippie-exp
    (defvar +snippets--smartparens-enabled-p t)
    (defvar +snippets--expanding-p nil)

    (add-hook 'yas-before-expand-snippet-hook
              (defun +snippets--disable-smartparens-before-expand-h ()
                (unless +snippets--expanding-p
                  (setq +snippets--expanding-p t
                        +snippets--smartparens-enabled-p smartparens-mode))
                (when smartparens-mode
                  (smartparens-mode -1))))

    (add-hook 'yas-after-exit-snippet-hook
              (defun +snippets--restore-smartparens-after-expand-h ()
                (setq +snippets--expanding-p nil)
                (when +snippets--smartparens-enabled-p
                  (smartparens-mode 1)))))

  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB")   nil)
  (define-key yas-keymap (kbd "<tab>")     #'yas-next-field)
  (define-key yas-keymap (kbd "TAB")       #'yas-next-field)
  (define-key yas-keymap (kbd "C-e")       #'yas-next-field)
  (define-key yas-keymap (kbd "C-a")       #'yas-prev-field)
  (define-key yas-keymap (kbd "M-<right>") #'yas-next-field)
  (define-key yas-keymap (kbd "M-<left>")  #'yas-prev-field)
  (define-key yas-keymap (kbd "<backspace>") #'yas-skip-and-clear-or-delete-char)
  (define-key yas-keymap (kbd "<delete>")    #'yas-skip-and-clear-or-delete-char))

(use-package yasnippet-snippets
  :straight t
  :ensure t
  :after yasnippet)

;;; Cape

(use-package cape
 :straight t
 :init
 (add-hook 'LaTeX-mode-hook
  (defun +snippets--setup-latex-capf-h ()
   (setq-local corfu-auto-prefix 1
               completion-at-point-functions
               (list #'yasnippet-capf
                     #'eglot-completion-at-point
                     (cape-capf-super #'yasnippet-capf
                                      #'TeX--completion-at-point
                                      #'cape-tex
                                      #'cape-dabbrev
                                      #'cape-file)))))
 (add-hook 'org-mode-hook
  (defun +snippets--setup-org-capf-h ()
   (setq-local completion-at-point-functions
               (list #'yasnippet-capf
                     (cape-capf-super #'cape-dabbrev
                                      #'cape-file))))))

;;; Yasnippet CAPF
(use-package yasnippet-capf
 :straight t
 :ensure
 :after (yasnippet corfu)
 :config
 (setq yasnippet-capf-lookup-by 'name)

 (with-eval-after-load 'corfu
  (setq corfu-auto        t
        corfu-auto-prefix 2
        corfu-sort-function #'identity))

 (defun +snippets--setup-eglot-capf ()
  (setq-local completion-at-point-functions
              (list (cape-capf-super #'yasnippet-capf
                                     #'eglot-completion-at-point
                                     #'cape-dabbrev
                                     #'cape-file)))
  (add-variable-watcher 'completion-at-point-functions
   (lambda (_sym val op _buf)
    (when (and (eq op 'set)
               (memq #'eglot-completion-at-point val))
     (setq-local completion-at-point-functions
                 (list (cape-capf-super #'yasnippet-capf
                                        #'eglot-completion-at-point
                                        #'cape-dabbrev
                                        #'cape-file)))))))

 (advice-add #'eglot-managed-mode :after #'+snippets--setup-eglot-capf)

 ;; For non-eglot prog-mode buffers
 (add-hook 'prog-mode-hook
  (defun +snippets--setup-prog-capf-h ()
   (setq-local completion-at-point-functions
               (list (cape-capf-super #'yasnippet-capf
                                      #'cape-dabbrev
                                      #'cape-file))))))

(provide 'snippet)
;;; snippet.el ends here 
