;;; lsp.el --- Comprehensive Eglot LSP configuration

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
  (vertico-cycle t))

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
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :straight t
  :ensure t
  :defer t
  :init
  (setq xref-show-xrefs-function    #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :bind
  (("C-x b"   . consult-buffer)
   ("C-x C-f" . consult-find)
   ("M-g g"   . consult-goto-line)
   ("M-s r"   . consult-ripgrep)
   ("M-s l"   . consult-line)
   ("M-s f"   . consult-fd)
   ("M-y"     . consult-yank-pop))
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
  :config
  (require 'corfu-popupinfo)
  (add-hook 'corfu-mode-hook #'corfu-popupinfo-mode)
  (setq corfu-popupinfo-delay '(0.5 . 0.3))
  :init
  (global-corfu-mode))
 
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
  :ensure t)
 
;; AUCTeX 
(use-package auctex
  :ensure t
  :defer t
  :hook (LaTeX-mode . TeX-source-correlate-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-mode t)         
  (TeX-source-correlate-start-server t)
  (TeX-engine 'luatex)
  (TeX-command-extra-options "-synctex=1"))                 
 
;; eldoc-box 
(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-mode))

(provide 'lsp)
;;; lsp.el ends here
