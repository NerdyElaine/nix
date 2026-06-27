;; elfeed.el starts here

(use-package elfeed
  :straight t
  :ensure t
  :after cl-lib
  :config
  )

(use-package elfeed-org
  :straight t
  :after elfeed
  :config
  (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))
  (elfeed-org))

(add-hook 'elfeed-show-mode-hook
  (lambda ()
    (setq buffer-face-mode-face '(:family "Crimson Pro" :height 160))
    (set-face-attribute 'line-number nil :font "AporeticSansMonoNerdFont")
    (set-face-attribute 'line-number-current-line nil :font "AporeticSansMonoNerdFont")
    (buffer-face-mode t)))

(custom-set-faces
 '(shr-text ((t (:family "Crimson Pro" :height 160))))
 '(shr-code ((t (:family "AporeticSansMonoNerdFont" :height 140)))))


;; elfeed.el ends here
