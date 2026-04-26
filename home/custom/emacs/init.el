;; Performance stuff
(setq gc-cons-threshold (* 128 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))
 
;; Straight.el bootstrap 
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
 
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
 
;; Defaults 
(use-package emacs
  :straight nil
  :custom
  (inhibit-startup-screen t)
  (initial-scratch-message nil)
  (ring-bell-function 'ignore)
  (use-short-answers t)
  (make-backup-files nil)
  (auto-save-default nil)
  (create-lockfiles nil)
  (tab-width 4)
  (indent-tabs-mode nil)
  (fill-column 80)
  (scroll-conservatively 101)
  (scroll-margin 4)
  :config
  (set-language-environment "UTF-8")
  (prefer-coding-system 'utf-8)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (column-number-mode 1)
  (setq default-frame-alist '((undecorated . t)))
  (global-auto-revert-mode 1)
  (recentf-mode 1)
  (show-paren-mode 1)
  (electric-pair-mode 1)
  (delete-selection-mode 1)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (add-hook 'text-mode-hook #'display-line-numbers-mode))
  (add-to-list 'default-frame-alist '(alpha . (96 . 96)))
 
(when (display-graphic-p)
  (set-face-attribute 'default nil :family "Iosevka" :height 130)
  (set-face-attribute 'variable-pitch nil :family "Iosevka" :height 140))
 
;; Themes
(straight-use-package
 '(everforest
   :type git
   :host github
   :repo "Theory-of-Everything/everforest-emacs"))

(load-theme 'everforest-hard-dark t)
 
;; Modules
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/custom/" user-emacs-directory))
