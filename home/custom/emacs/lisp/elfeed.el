;; elfeed.el starts here

(use-package elfeed
  :straight t
  :ensure t
  :after cl-lib
  :config
  )

(use-package elfeed-org
  :ensure t
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org")))
