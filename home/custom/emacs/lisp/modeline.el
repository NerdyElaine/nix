;;; modeline.el -*- lexical-binding: t; -*-

(use-package nerd-icons
             :straight t
             :demand t)

(use-package doom-modeline
  :straight t
  :demand t
  :config
  (setq doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-lsp-icon t
        doom-modeline-major-mode-color-icon t)
  (doom-modeline-mode 1))

(provide 'modeline)
