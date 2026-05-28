;;; post-init.el --- Init -*- lexical-binding: t; -*-

;;Modules 
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(require 'meow-setup)
(require 'vterm-config)
(require 'tabs)
(require 'emms-config)
(require 'modeline)
(require 'snippet)
(require 'lsp)
(require 'dired-config)
(require 'magit-config)
(require 'org-config)
(require 'markdown)
(require 'workspaces)
(require 'elfeed)
(require 'pdf)
(require 'flash)
(require 'emment)
(require 'move-text-config)
(require 'erc-config)
;;; post-init.el ends here
