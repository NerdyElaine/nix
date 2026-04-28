;;; eglot-config.el --- Comprehensive Eglot LSP configuration
 

;;; Core Eglot settings

 
(use-package eglot
  :ensure nil 
  :hook
  ((c-mode             . eglot-ensure)
   (c-ts-mode          . eglot-ensure)
   (c++-mode           . eglot-ensure)
   (c++-ts-mode        . eglot-ensure)
   (rust-mode          . eglot-ensure)
   (rust-ts-mode       . eglot-ensure)
   (python-mode        . eglot-ensure)
   (python-ts-mode     . eglot-ensure)
   (nix-mode           . eglot-ensure)
   (html-mode          . eglot-ensure)
   (css-mode           . eglot-ensure)
   (js-mode            . eglot-ensure)
   (js-ts-mode         . eglot-ensure)
   (typescript-mode    . eglot-ensure)
   (tsx-ts-mode        . eglot-ensure)
   (typescript-ts-mode . eglot-ensure)
   (haskell-mode       . eglot-ensure)
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
               '(nix-mode . ("nixd")))
 
  ;; HTML : vscode-html-language-server 
  (add-to-list 'eglot-server-programs
               '(html-mode . ("vscode-html-language-server" "--stdio")))
 
  ;; CSS : vscode-css-language-server 
  (add-to-list 'eglot-server-programs
               '(css-mode . ("vscode-css-language-server" "--stdio")))
 
  ;; JavaScript / TypeScript : tslsp 
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode
                  typescript-mode typescript-ts-mode tsx-ts-mode)
                 . ("typescript-language-server" "--stdio")))
 
  ;; Haskell : haskell-language-server 
  (add-to-list 'eglot-server-programs
               '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
 
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
 
(add-hook 'nix-mode-hook #'my/nix-eglot-config)
 
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
 
;;; Corfu 
 
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
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-source-correlate-mode t)         
  (TeX-source-correlate-start-server t)
  (TeX-engine 'luatex))                 
 
;; eldoc-box 
(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-mode))

(provide 'lsp)
;;; eglot-config.el ends here
