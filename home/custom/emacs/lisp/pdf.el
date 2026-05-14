;;; pdf.el --- Pdf config with synctex -*-lexical-binding: t; -*-

(use-package pdf-tools
  :straight (:host github :repo "vedang/pdf-tools")
  :ensure t
  :demand t
  :init
    (setq pdf-info-epdfinfo-program
        (expand-file-name "/Users/elaine/.emacs.d/straight/build/pdf-tools/build/server/epdfinfo"
                          user-emacs-directory))
  :config
  (pdf-tools-install)
  (add-hook 'pdf-view-mode-hook #'pdf-view-midnight-minor-mode)
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-continuous t)
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")))
  (setq TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

(provide 'pdf)
;;; pdf.el ends here
