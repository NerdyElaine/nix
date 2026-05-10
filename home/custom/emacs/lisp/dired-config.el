;;; dired-config.el --- Dired/dirvish config -*- lexical-binding: t; -*-

(use-package dired
  :straight nil
  :ensure nil
  :custom
  (insert-directory-program "/run/current-system/sw/bin/gls")
  (dired-listing-switches "-lAh --group-directories-first --no-group")
  (dired-dwin-target t)
  (dired-recursive-copies 'always)
  (dired-auto-revert-buffer t)
  (dired-recursive-deletes 'top)
  (delete-by-moving-to-trash t))

;; Filter out noise from gls
(defun my-dired-filter-apple-sharpener ()
  (when (and (buffer-live-p (current-buffer))
             (derived-mode-p 'dired-mode))
    (let ((inhibit-read-only t))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "^.*AppleSharpener.*\n" nil t)
          (replace-match ""))))))

(add-hook 'dired-after-readin-hook #'my-dired-filter-apple-sharpener)

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package image-dired
  :ensure nil
  :after dired
  :custom
  (image-dired-thumb-size 150)
  (image-dired-thumb-margin 4)
  (image-dired-thumbnail-storage 'standard)
  :bind (:map dired-mode-map
         ("C-t d"   . image-dired-display-thumbs)
         ("C-t C-t" . image-dired-dired-toggle-marked-thumbs)
         ("C-t f"   . image-dired-dired-display-external)))

(use-package dired-preview
  :ensure t
  :custom
  (dired-preview-delay 0.1)
  (dired-preview-max-size (* 10 1024 1024)) ; skip files over 10MB
  (dired-preview-ignored-extensions-regexp
   (concat "\\."
           (regexp-opt '("mkv" "mp4" "iso" "exe" "dmg") t)
           "\\'"))
  :hook (dired-mode . dired-preview-mode))

(use-package doc-view
  :ensure nil
  :custom
  (doc-view-resolution 150)
  (doc-view-continuous t))

(provide 'dired-config)

;;; dired-config ends here
