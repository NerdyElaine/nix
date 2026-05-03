;;; magit.el --- Description -*- lexical-binding: t; -*-
(use-package magit-section
  :straight t
  :demand t)
(use-package magit
  :defer t
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
        magit-bury-buffer-function #'magit-restore-window-configuration
        magit-git-executable "/run/current-system/sw/bin/git"))

(defun my/magit-git-version (&optional error)
  (let* ((output (mapconcat #'identity
                             (ignore-errors
                               (let (magit-git-global-arguments)
                                 (process-lines magit-git-executable "--version")))
                             "\n"))
         (match (when (string-match "git version \\([0-9]+\\(\\.[0-9]+\\)*\\)" output)
                  (match-string 1 output))))
    match))
(advice-add 'magit-git-version :override #'my/magit-git-version)
(add-hook 'git-commit-mode-hook #'meow-insert)
(with-eval-after-load 'magit
  (define-key magit-mode-map (kbd "n") #'next-line)
  (define-key magit-mode-map (kbd "e") #'previous-line)
  (define-key magit-mode-map (kbd "m") #'backward-char)
  (define-key magit-mode-map (kbd "i") #'forward-char)
  (define-key magit-status-mode-map (kbd "p") #'magit-push)
  (define-key magit-status-mode-map (kbd "SPC") nil)
  (define-key magit-log-mode-map (kbd "SPC") nil)
  (define-key magit-diff-mode-map (kbd "SPC") nil))

(provide 'magit-config)
