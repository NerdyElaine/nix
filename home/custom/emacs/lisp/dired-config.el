;;; dired-config.el --- Dired/dirvish config -*- lexical-binding: t; -*-

(use-package dired
  :straight nil
  :ensure nil
  :custom
  (setq insert-directory-program "/run/current-system/sw/bin/gls")
  (dired-listing-switches "-lAh --group-directories-first --no-group")
  (dired-dwin-target t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (delete-by-moving-to-trash t))

(use-package dirvish
  :straight t
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-default-layout '(1 0.11 0.55))
  (dirvish-layout-recipes
   '((0 0    0.4)
     (0 0    0.8)   
     (1 0.08 0.5)   
     (1 0.11 0.55)  
     (1 0.15 0.6)))
  )

(defun my-dired-filter-apple-sharpener ()
  (when (and (buffer-live-p (current-buffer))
             (derived-mode-p 'dired-mode))
    (let ((inhibit-read-only t))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "^.*AppleSharpener.*\n" nil t)
          (replace-match ""))))))

(add-hook 'dired-after-readin-hook #'my-dired-filter-apple-sharpener)

(with-eval-after-load 'dirvish
  (add-hook 'dirvish-after-revert-hook #'my-dired-filter-apple-sharpener))

(provide 'dired-config)

;;; dired-config ends here
