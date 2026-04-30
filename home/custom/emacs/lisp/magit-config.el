;;; magit.el --- Description -*- lexical-binding: t; -*-
(use-package magit-section
  :straight t
  :demand t)

(use-package magit
  :defer t
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
        magit-bury-buffer-function #'magit-restore-window-configuration
        setq magit-git-executable "/run/current-system/sw/bin/git"))

(add-hook 'git-commit-mode-hook #'meow-insert)

(with-eval-after-load 'magit
  (define-key magit-status-mode-map (kbd "p") #'magit-push)
  (define-key magit-status-mode-map (kbd "SPC") nil)
  (define-key magit-log-mode-map (kbd "SPC") nil)
  (define-key magit-diff-mode-map (kbd "SPC") nil))

(provide 'magit-config)
