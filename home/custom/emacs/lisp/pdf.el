;;; pdf.el --- Pdf config with synctex -*-lexical-binding: t; -*-

(use-package pdf-tools
  :straight (:host github :repo "vedang/pdf-tools")
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :demand t
  :init
    (setq pdf-info-epdfinfo-program
        (expand-file-name "/Users/elaine/.emacs.d/straight/build/pdf-tools/build/server/epdfinfo"
                          user-emacs-directory))
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-continuous t)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)
  (add-hook 'pdf-view-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)
            (run-with-idle-timer 0.5 nil
                                 (lambda ()
                                   (when (derived-mode-p 'pdf-view-mode)
                                     (setq pdf-view-midnight-colors
                                           `(,(face-attribute 'default :foreground nil t) .
                                             ,(face-attribute 'default :background nil t)))
                                     (pdf-view-midnight-minor-mode 1))))))
  (define-key pdf-view-mode-map (kbd "m") #'image-backward-hscroll)
  (define-key pdf-view-mode-map (kbd "i") #'image-forward-hscroll)
  (define-key pdf-view-mode-map (kbd "n") #'pdf-view-next-line-or-next-page)
  (define-key pdf-view-mode-map (kbd "e") #'pdf-view-previous-line-or-previous-page)
  (define-key pdf-view-mode-map (kbd "N") #'pdf-view-next-page)
  (define-key pdf-view-mode-map (kbd "E") #'pdf-view-previous-page)
  (define-key pdf-view-mode-map (kbd "=") #'pdf-view-enlarge)
  (define-key pdf-view-mode-map (kbd "-") #'pdf-view-shrink)
  (define-key pdf-view-mode-map (kbd "o") #'pdf-outline)
  (define-key pdf-view-mode-map (kbd "W") #'pdf-view-fit-width-to-window)
  (define-key pdf-view-mode-map (kbd "P") #'pdf-view-fit-page-to-window))

(provide 'pdf)
;;; pdf.el ends here
