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
    (setq buffer-face-mode-face '(:family "Garamond Libre" :height 160))
    (buffer-face-mode t)))

(custom-set-faces
 '(shr-text ((t (:family "Garamond Libre" :height 160))))
 '(shr-code ((t (:family "Iosevka" :height 140)))))


;; elfeed.el ends here
