;;; post-init.el --- Init -*- lexical-binding: t; -*-

;;Modules 
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(require 'meow-setup)
(require 'vterm-config)
(require 'tabs)
(require 'emms-config)
(require 'modeline)
(require 'lsp)
;;; post-init.el ends here
