;; vterm-config.el --- vterm configuration -*- lexical-binding: t; -*-

(use-package vterm
  :straight t
  :defer t
  :init
  (setq vterm-timer-delay 0.05
        vterm-kill-buffer-on-exit t
        vterm-max-scrollback 5000)

  :config
  ;; macOS: ensure module exists before continuing
  (unless (file-exists-p
           (expand-file-name "build/vterm-module.dylib"
                             (straight--repos-dir "emacs-libvterm")))
    (message "[vterm] module not built. Run: cd ~/.emacs.d/straight/repos/emacs-libvterm && mkdir -p build && cd build && cmake .. && make"))

  (setq vterm-buffer-name-string "vterm %s"
        vterm-environment '("TERM=xterm-256color"))

  ;; Respect current directory
  (defun +vterm--respect-current-dir (fn &rest args)
    (let ((default-directory
            (or (and (buffer-file-name)
                     (file-name-directory (buffer-file-name)))
                (and (eq major-mode 'dired-mode)
                     (dired-current-directory))
                default-directory)))
      (apply fn args)))
  (advice-add 'vterm :around #'+vterm--respect-current-dir)

  ;; Mode setup
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq-local confirm-kill-processes nil)
              (setq-local hscroll-margin 0)
              (setq-local mode-line-format nil)
              (setq-local buffer-face-mode-face
                          '(:family "Iosevka Nerd Font Mono"))
              (buffer-face-mode 1)))

  ;; Windmove keys
  (define-key vterm-mode-map (kbd "C-<left>")  #'windmove-left)
  (define-key vterm-mode-map (kbd "C-<right>") #'windmove-right)
  (define-key vterm-mode-map (kbd "C-<up>")    #'windmove-up)
  (define-key vterm-mode-map (kbd "C-<down>")  #'windmove-down)

  ;; Meow integration
  (add-hook 'vterm-mode-hook #'meow-insert-mode)

  (define-key vterm-mode-map (kbd "<escape>")
              (lambda ()
                (interactive)
                (meow-normal-mode)
                (vterm-copy-mode 1)))

  (define-key vterm-copy-mode-map (kbd "i")
              (lambda ()
                (interactive)
                (vterm-copy-mode -1)
                (meow-insert-mode)))

  (define-key vterm-copy-mode-map (kbd "y") #'meow-clipboard-save)
  (define-key vterm-copy-mode-map (kbd "l") #'meow-line)
  (define-key vterm-copy-mode-map (kbd "L")
              (lambda () (interactive) (meow-line 1) (meow-reverse)))
  (define-key vterm-copy-mode-map (kbd "m") #'meow-mark-word)
  (define-key vterm-copy-mode-map (kbd "f") #'flash-jump)
  (define-key vterm-copy-mode-map (kbd "/") #'consult-line)
  (define-key vterm-copy-mode-map (kbd "n") #'meow-next)
  (define-key vterm-copy-mode-map (kbd "e") #'meow-prev)
  (define-key vterm-copy-mode-map (kbd "h") #'meow-left)
  (define-key vterm-copy-mode-map (kbd "w") #'meow-next-word)
  (define-key vterm-copy-mode-map (kbd "b") #'meow-back-word)
  (define-key vterm-copy-mode-map (kbd ";") #'meow-reverse)
  (define-key vterm-copy-mode-map (kbd "v") #'meow-search)
  (define-key vterm-copy-mode-map (kbd "V") #'meow-visit)
  (define-key vterm-copy-mode-map (kbd "g") #'meow-cancel-selection)

  (define-key vterm-copy-mode-map (kbd "<escape>")
              (lambda ()
                (interactive)
                (vterm-copy-mode -1)
                (meow-insert-mode))))

;; Frame behavior

(defun my/vterm-in-new-frame (frame)
  (unless (or (frame-parameter frame 'main-frame)
              (frame-parameter frame 'explicit-vterm))
    (with-selected-frame frame
      (delete-other-windows)
      (ignore-errors
        (let ((buf (vterm (format "*vterm-%s*" (frame-parameter frame 'name)))))
          (switch-to-buffer buf)
          (delete-other-windows))))))

(add-hook 'after-make-frame-functions #'my/vterm-in-new-frame)

(defun my/tag-initial-frame ()
  (set-frame-parameter nil 'main-frame t))
(add-hook 'emacs-startup-hook #'my/tag-initial-frame)

(defun my/new-frame-with-vterm ()
  (interactive)
  (let ((frame (make-frame '((explicit-vterm . t)))))
    (select-frame frame)
    (delete-other-windows)
    (ignore-errors
      (switch-to-buffer
       (vterm (format "*vterm-%s*" (frame-parameter frame 'name)))))))

;; Popup terminal

(defun jb/vterm ()
  (interactive)
  (if (require 'vterm nil t)
      (let ((buf (get-buffer-create "*vterm*")))
        (with-current-buffer buf
          (unless (derived-mode-p 'vterm-mode)
            (vterm-mode)))
        (select-window
         (display-buffer
          buf
          '((display-buffer-reuse-window
             display-buffer-in-side-window)
            (side . bottom)
            (window-height . 0.3)))))
    (message "vterm not available (build module?)")))

(provide 'vterm-config)
;;; vterm.el ends here
