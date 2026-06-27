;;; writing.el --- Writing configuration for writing in emacs

(global-visual-line-mode)
(setq sentence-end-double-space nil)

(use-package ispell
  :straight nil  ;
  :defer t
  :init
  ;; Point to your Homebrew Hunspell executable
  (setq ispell-program-name "/opt/homebrew/bin/hunspell")
  
  :config
  ;; Tell Hunspell where to look for the dictionaries we just downloaded
  (setenv "DICPATH" (expand-file-name "~/Library/Spelling"))
  
  ;; Set the default language
  (setq ispell-default-dictionary "en_US")
  (setq ispell-dictionary "en_US")
  
  ;; Map the dictionary metadata file explicitly so Emacs registers it
  (setq ispell-hunspell-dict-paths-alist
        '(("en_US" "~/Library/Spelling/en_US.aff")))
  
  ;; Explicitly tell Emacs it's working with Hunspell
  (setq ispell-really-hunspell t))

(use-package flyspell
  :straight nil
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode))) ; Only checks comments & strings in code files

(use-package olivetti
  :straight t
  :bind (("C-c v" . olivetti-mode))
  :init
  (setq olivetti-body-width 80)
  
  :config
  ;; Always wrap text when olivetti is active
  (add-hook 'olivetti-mode-hook #'visual-line-mode)
  
  ;; Hide line numbers safely when Olivetti turns on
  (add-hook 'olivetti-mode-hook
            (lambda ()
              (if olivetti-mode
                  (display-line-numbers-mode -1)
                (display-line-numbers-mode 1))))
                
  ;; Hook into text, org, and ONLY individual elfeed articles
  (add-hook 'elfeed-show-mode-hook #'olivetti-mode))

(provide 'writing)
;;; writing.el ends here
