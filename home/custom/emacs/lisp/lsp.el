;;; lsp.el --- Comprehensive Eglot LSP configuration
(server-start)

;; Mason.el for installing needed lsps
(use-package mason
  :straight t
  :ensure t
  :config
  (mason-setup)
 )

;; Treesitter
(use-package treesit
  :straight nil
  :ensure nil
  :init
  ;; Must be in :init — remap must exist before any buffer opens.
  ;; :config is too late; treesit may already be loaded.
  (setq major-mode-remap-alist
        '((go-mode         . go-ts-mode)
          (python-mode     . python-ts-mode)
          (javascript-mode . js-ts-mode)
          (css-mode        . css-ts-mode)
          (html-mode       . html-ts-mode)
          (nix-mode        . nix-ts-mode)
          (c-mode          . c-ts-mode)))
  (setq treesit-language-source-alist
        '(
          (nix        "https://github.com/nix-community/tree-sitter-nix")
          (python     "https://github.com/tree-sitter/tree-sitter-python")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src") 
          (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")        
          (css        "https://github.com/tree-sitter/tree-sitter-css")
          (c          "https://github.com/tree-sitter/tree-sitter-c")
          (cpp        "https://github.com/tree-sitter/tree-sitter-cpp")      
          (rust       "https://github.com/tree-sitter/tree-sitter-rust")
          (haskell    "https://github.com/tree-sitter/tree-sitter-haskell") 
          (python     "https://github.com/tree-sitter/tree-sitter-python")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
          (css        "https://github.com/tree-sitter/tree-sitter-css")
          (html       "https://github.com/tree-sitter/tree-sitter-html"))))

(dolist (entry '(
                 ("\\.ts\\'"  . typescript-ts-mode)
                 ("\\.tsx\\'" . tsx-ts-mode)
                 ("\\.c\\'"   . c-ts-mode)
                 ("\\.h\\'"   . c-ts-mode)
                 ("\\.cpp\\'" . c++-ts-mode)
                 ("\\.cc\\'"  . c++-ts-mode)
                 ("\\.hpp\\'" . c++-ts-mode)))  
  (add-to-list 'auto-mode-alist entry))

(defun my/treesit-install-all-grammars ()
  (interactive)
  (dolist (lang (mapcar #'car treesit-language-source-alist))
    (unless (treesit-language-available-p lang)
      (message "Installing tree-sitter grammar for %s..." lang)
      (treesit-install-language-grammar lang))))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

;;; Core Eglot settings
 
(use-package eglot
  :ensure nil 
  :hook
   ((c-ts-mode          . eglot-ensure)
   (c++-ts-mode        . eglot-ensure)
   (rust-ts-mode       . eglot-ensure)
   (python-ts-mode     . eglot-ensure)
   (nix-ts-mode        . eglot-ensure)
   (html-ts-mode       . eglot-ensure)
   (css-ts-mode        . eglot-ensure)
   (js-ts-mode         . eglot-ensure)
   (tsx-ts-mode        . eglot-ensure)
   (typescript-ts-mode . eglot-ensure)
   (haskell-ts-mode    . eglot-ensure)
   (latex-mode         . eglot-ensure)
   (LaTeX-mode         . eglot-ensure))
 
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-connect-timeout 30)
  (eglot-send-changes-idle-time 0.1)
 
  :config
   (add-to-list 'exec-path "/run/current-system/sw/bin")
   (setenv "PATH" (concat "/run/current-system/sw/bin:" (getenv "PATH")))           
  ;; C / C++ : clangd
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode)
                 . ("clangd"
                    "--background-index"         
                    "--clang-tidy"               
                    "--completion-style=detailed"
                    "--header-insertion=iwyu"     
                    "--log=error")))
 
  ;;  Rust : rust-analyzer
  (add-to-list 'eglot-server-programs
               '((rust-mode rust-ts-mode) . ("rust-analyzer")))
 
  ;;  Python : Basedpyright 
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 . ("basedpyright-langserver" "--stdio")))
 
  ;;  Nix : nixd 
  (add-to-list 'eglot-server-programs
               '((nix-mode nix-ts-mode) . ("/run/current-system/sw/bin/nixd")))
 
  ;; HTML : vscode-html-language-server 
  (add-to-list 'eglot-server-programs
               '((html-mode html-ts-mode) . ("vscode-html-language-server" "--stdio")))
 
  ;; CSS : vscode-css-language-server 
  (add-to-list 'eglot-server-programs
               '((css-mode css-ts-mode) . ("vscode-css-language-server" "--stdio")))
 
  ;; JavaScript / TypeScript : tslsp 
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode
                  typescript-mode typescript-ts-mode tsx-ts-mode)
                 . ("typescript-language-server" "--stdio")))
 
  ;; Haskell : haskell-language-server 
  (add-to-list 'eglot-server-programs
               '((haskell-mode haskell-ts-mode) . ("haskell-language-server-wrapper" "--lsp")))
 
  ;; LaTeX : texlab 
  (add-to-list 'eglot-server-programs
               '((latex-mode LaTeX-mode) . ("texlab"))))
 
;;; LSP configuration 

;; Rust  
(defun my/rust-eglot-config ()
  (setq-local eglot-workspace-configuration
              '(:rust-analyzer
                (:checkOnSave  (:command "clippy")  
                 :cargo        (:allFeatures t)
                 :procMacro    (:enable t)
                 :inlayHints   (:parameterHints (:enable t)
                                :typeHints      (:enable t)
                                :chainingHints  (:enable t))))))
 
(add-hook 'rust-mode-hook    #'my/rust-eglot-config)
(add-hook 'rust-ts-mode-hook #'my/rust-eglot-config)
 
;; Python : Basedpyright settings 
(defun my/python-eglot-config ()
  (setq-local eglot-workspace-configuration
              '(:basedpyright
                (:analysis
                 (:typeCheckingMode       "standard"  ; "off" | "basic" | "standard" | "strict" | "all"
                  :useLibraryCodeForTypes t
                  :autoImportCompletions  t
                  :diagnosticMode         "openFilesOnly")))))
 
(add-hook 'python-mode-hook    #'my/python-eglot-config)
(add-hook 'python-ts-mode-hook #'my/python-eglot-config)
 
;; Nix : nixd settings 
(defun my/nix-eglot-config ()
  (setq-local eglot-workspace-configuration
              '(:nixd
                (:nixpkgs
                 (:expr "import <nixpkgs> {}")
                 :formatting
                 (:command ["alejandra"])    
                 ;; Uncomment and fill in your config attributes:                 ;; :options
                 ;; (:nixos        (:expr "(builtins.getFlake \"/path/to/flake\").nixosConfigurations.hostname.options")
                 ;;  :home-manager (:expr "(builtins.getFlake \"/path/to/flake\").homeConfigurations.\"user\".options"))
                 ))))
(advice-add 'browse-url :around
  (lambda (orig url &rest args)
    (unless (string-match-p "nixos\\.org\\|search\\.nixos" url)
      (apply orig url args))))

(add-hook 'nix-mode-hook #'my/nix-eglot-config)
(add-hook 'nix-ts-mode-hook #'my/nix-eglot-config)

;; Haskell : HLS settings 
(defun my/haskell-eglot-config ()
  (setq-local eglot-workspace-configuration
              '(:haskell
                (:formattingProvider "fourmolu"   ; "ormolu" | "fourmolu" | "stylish-haskell" | "brittany"
                 :checkProject       t
                 :plugin
                 (:stan   (:globalOn :json-false)
                  :retrie (:globalOn :json-false))))))
 
(add-hook 'haskell-mode-hook #'my/haskell-eglot-config)
 
;; LaTeX : texlab settings 
(defun my/latex-eglot-config ()
  (setq-local eglot-workspace-configuration
              '(:texlab
                (:build
                 (:executable "latexmk"
                  :args       ["-pdf" "-interaction=nonstopmode" "-synctex=1" "%f"]
                  :onSave     t)
                 :chktex
                 (:onOpenAndSave t)
                 :inlayHints
                 (:labelDefinitions t
                  :labelReferences   t)))))
 
(add-hook 'latex-mode-hook #'my/latex-eglot-config)
(add-hook 'LaTeX-mode-hook #'my/latex-eglot-config)
 
;;; Completion
(use-package vertico
  :straight t
  :ensure t
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t)
  (vertico-count 20)
  (vertico-preselect 'first))

(use-package marginalia
  :straight t
  :ensure t
  :init
  (marginalia-mode 1))

(use-package orderless
  :straight t
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(setq consult-async-min-input 0)

(use-package consult
  :straight t
  :ensure t
  :defer t
  :init
  (setq xref-show-xrefs-function    #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   :preview-key '(:debounce 0.4 any)))

(use-package embark
  :straight t 
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)))

(use-package embark-consult
  :straight t
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :straight t
  :ensure t
  :custom
  (corfu-auto t)              
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)       
  (corfu-cycle t)             
  (corfu-quit-no-match t)
  (corfu-confirm-commit nil)
  :config
  (require 'corfu-popupinfo)
  (add-hook 'corfu-mode-hook #'corfu-popupinfo-mode)
  (setq corfu-popupinfo-delay '(0.5 . 0.3))
  (setq corfu-confirm-completion nil) 
(with-eval-after-load 'corfu
  (keymap-unset corfu-map "RET"))
 (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq-local corfu-auto t)
              ;; Make sure AUCTeX's own capf is present
              (add-to-list 'completion-at-point-functions
                           #'TeX--completion-at-point)))
 :bind
 (:map corfu-map
        ("RET"   . nil)        ; disable enter globally in corfu
        ("<ret>" . nil)
        ("TAB"   . corfu-insert)
        ("<tab>" . corfu-insert))
  :init
(global-corfu-mode))

(use-package cape
  :init
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq-local corfu-auto-prefix 1)
              (setq-local completion-at-point-functions
                          (list
                           #'yasnippet-capf              ; first, always checked
                           #'eglot-completion-at-point   ; then LSP
                           (cape-capf-super
                            #'yasnippet-capf
                            #'TeX--completion-at-point
                            #'cape-tex
                            #'cape-dabbrev
                            #'cape-file))))))

    (use-package yasnippet-capf
      :after (yasnippet corfu)
      :config
      (setq yasnippet-capf-lookup-by 'key)
      ;; Make TAB expand the selected snippet candidate
      (advice-add 'corfu-insert :after
                  (lambda (&rest _)
                    (when (and (bound-and-true-p yas-minor-mode)
                               (looking-back "\\w" 1))
                      (yas-expand)))))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Editing convenience
(use-package undo-tree
  :straight t
  :ensure t
  :demand t
  :config
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo-tree-history" user-emacs-directory))))
  (global-undo-tree-mode 1))


(defvar highlight-codetags-keywords
  '(("\\<\\(TODO\\|FIXME\\|BUG\\|XXX\\)\\>" 1 font-lock-warning-face prepend)
    ("\\<\\(NOTE\\|HACK\\)\\>" 1 font-lock-doc-face prepend)))

(define-minor-mode highlight-codetags-local-mode
  "Highlight codetags like TODO, FIXME..."
  :global nil
  (if highlight-codetags-local-mode
      (font-lock-add-keywords nil highlight-codetags-keywords)
    (font-lock-remove-keywords nil highlight-codetags-keywords))

  ;; Fontify the current buffer
  (when (bound-and-true-p font-lock-mode)
    (if (fboundp 'font-lock-flush)
        (font-lock-flush)
      (with-no-warnings (font-lock-fontify-buffer)))))

(add-hook 'prog-mode-hook #'highlight-codetags-local-mode)

;;; Keymaps
 
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c r")   #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c a")   #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c f")   #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c F")   #'eglot-format-buffer)
  (define-key eglot-mode-map (kbd "C-c d")   #'eldoc)
  (define-key eglot-mode-map (kbd "M-.")     #'xref-find-definitions)
  (define-key eglot-mode-map (kbd "M-,")     #'xref-go-back)
  (define-key eglot-mode-map (kbd "M-?")     #'xref-find-references)
  (define-key eglot-mode-map (kbd "C-c i")   #'eglot-find-implementation)
  (define-key eglot-mode-map (kbd "C-c t")   #'eglot-find-typeDefinition))
 
 

;;; Supporting major-mode packages

 
;; Nix
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")
 
;; Haskell
(use-package haskell-mode
  :ensure t)
 
;; Rust 
(use-package rust-mode
  :ensure t
  :custom (rust-format-on-save nil)) 
 
;; TypeScript 
(use-package typescript-mode
  :ensure t
  :after flyspell)
 
;; AUCTeX 
(use-package auctex
  :defer t
  :hook
  (LaTeX-mode . LaTeX-math-mode)
  (LaTeX-mode . flyspell-mode)
  (LaTeX-mode . auto-fill-mode)
  (LaTeX-mode . visual-line-mode)
  :custom
  (TeX-save-query nil)
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  (TeX-command-default "LatexMk")
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-start-server t)
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  (TeX-PDF-mode t)
  :config
  ;; This must be in :config, not :custom — it's not a simple value
  (setq TeX-view-program-list
        '(("PDF Tools" TeX-pdf-tools-sync-view)))
  (setq revert-without-query '(".*\\.pdf"))
  (add-hook 'TeX-after-compilation-finished-functions
            (lambda (file)
              (run-with-timer 1 nil #'TeX-revert-document-buffer file)))
  (add-hook 'after-save-hook
          (lambda ()
            (when (eq major-mode 'LaTeX-mode)
              (let ((TeX-save-query nil))
                (TeX-command-run-all nil))))))

(use-package auctex-latexmk
  :after auctex
  :custom
  (auctex-latexmk-inherit-TeX-PDF-mode t)
  (auctex-latexmk-options "-pdf -pvc -interaction=nonstopmode")
  :config
  (auctex-latexmk-setup)
 )

(use-package reftex
  :after auctex
  :hook (LaTeX-mode . reftex-mode)
  :custom
  (reftex-plug-into-AUCTeX t)
  (reftex-save-parse-info t)
  (reftex-use-multiple-selection-buffers t))

(use-package company
  :hook (LaTeX-mode . company-mode)
  :custom
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 2))

(use-package company-auctex
  :after (company auctex)
  :config (company-auctex-init))

(use-package company-reftex
  :after (company reftex)
  :config
  (add-to-list 'company-backends
               '(company-reftex-labels company-reftex-citations)))

(use-package cdlatex
  :hook (LaTeX-mode . cdlatex-mode))

;; eldoc-box 
(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-mode))

(provide 'lsp)
;;; lsp.el ends here
