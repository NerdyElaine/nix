;;; tabs.el --- Description -*- lexical-binding: t; -*-

(defun my/centaur-tabs-group-by-project ()
  "Group centaur-tabs tabs by project.el project root."
  (let* ((buf (current-buffer))
         (file (buffer-file-name buf)))
    (if (and file (project-current nil (file-name-directory file)))
        ;; Return project root name as the group
        (file-name-nondirectory
         (directory-file-name
          (project-root (project-current nil (file-name-directory file)))))
      ;; Fall back to "Other" for buffers not in a project
      "Other")))

(use-package centaur-tabs
  :ensure t
  :demand t
  :init
  (setq centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-bar 'left
        centaur-tabs-set-modified-marker t
        centaur-tabs-close-button "✕"
        centaur-tabs-modified-marker "•"
        centaur-tabs-icon-type 'nerd-icons
        centaur-tabs-cycle-scope 'tabs
        centaur-tabs-style "bar"
        centaur-tabs-height 32)
  :config
  ;; Filter out temp/ephemeral buffers from tabs
  (defun my/tabs-buffer-list ()
    (seq-filter
     (lambda (b)
       (when (buffer-live-p b)
         (let ((name (buffer-name b)))
           (not (or (string-prefix-p " " name)
                    (string-prefix-p "*" name)
                    (string= name ""))))))
     (buffer-list)))

  (setq centaur-tabs-buffer-list-function #'my/tabs-buffer-list)

  ;; Disable tabs in transient/popup-like buffers
  (dolist (hook '(dashboard-mode-hook
                  calendar-mode-hook
                  helpful-mode-hook
                  help-mode-hook))
    (add-hook hook #'centaur-tabs-local-mode))

  (centaur-tabs-mode 1)
  (centaur-tabs-group-by-projectile-project))

;; Keybindings — match Doom's defaults
(with-eval-after-load 'centaur-tabs
  (define-key centaur-tabs-mode-map (kbd "<C-tab>")         #'centaur-tabs-forward)
  (define-key centaur-tabs-mode-map (kbd "<C-S-tab>") #'centaur-tabs-backward))

(provide 'tabs)
;;; tabs.el ends here
