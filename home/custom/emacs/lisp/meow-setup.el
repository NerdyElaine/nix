;;; meow-setup.el --- Description -*- lexical-binding: t; -*-

;; Setup if there are any leader keys breaking
;; (defvar my-leader-map (make-sparse-keymap) "Primary leader keymap.")

;; define keys
(setq meow-keypad-ctrl-meta-prefix ?G)
(setq meow-keypad-meta-prefix ?M)

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-colemak-dh)

  (meow-leader-define-key
   '("?" . meow-cheatsheet)

   ;; Files and Consult
   '("n r" . nil)  
   '("." . find-file)
   '("SPC" . my/project-find-file)
   '("p a" . my/project-add)
   '("p R" . project-query-replace-regexp)
   '("/" . consult-ripgrep)
   '("f r" . consult-recent-file)
   '("f y" . my/yank-buffer-path)
   '("f d" . dired-jump)
   
      ;; Workspaces
   '("<TAB> s" . easysession-save)
   '("<TAB> l" . easysession-switch-to)
   '("<TAB> R" . easysession-rename)
   '("<TAB> D" . easysession-delete)
   '("<TAB> <TAB>" . +workspace/display)
   '("<TAB> n" . +workspace/new)
   '("<TAB> d" . +workspace/delete)
   '("<TAB> r" . +workspace/rename)
   '("<TAB> ." . +workspace/switch-to)
   '("<TAB> [" . tab-bar-switch-to-prev-tab)
   '("<TAB> ]" . tab-bar-switch-to-next-tab)
   '("p p" . +workspace/switch-to-project)
   
   ;; Window bindings
   '("w v" . split-window-right)
   '("w s" . split-window-below)
   '("w d" . delete-window)

   ;; Buffer
   '("," . consult-buffer)
   '("b k" . (lambda () (interactive) (kill-buffer (current-buffer))))
   '("b l" . (lambda () (interactive) (switch-to-buffer nil)))
   '("b b" . switch-to-buffer)
   '("b n" . next-buffer)
   '("b i" . ibuffer)
   '("b S" . my/save-all-buffers)

   ;; Bookmarks
   '("b m" . bookmark-set)
   '("b P" . bookmark-save)
   '("b D" . bookmark-delete)
   '("RET" . bookmark-jump)
   '("o b" . browse-url-of-file)

   ;; Org
   '("n c" . org-roam-capture)
   '("n C" . org-capture)
   '("n f" . org-roam-node-find)
   '("n j" . org-roam-dailies-capture-today)
   '("n g" . org-roam-ui-open)

   ;; Magit
   '("g" . (lambda () (interactive) (require 'magit) (magit-status)))

   ;; Miscellaneous
   '("o t" . my/vterm)
   '("o T" . vterm)
   '("s t" . dictionary-search)
   '("e e" . elfeed)
   '("s l" . link-hint-open-link)
   '("B" . my/scratch-popup)
   '("i d" . wdired-change-to-wdired-mode)

   ;; Testing
   '("m t a" . my/test-all)
   '("m t f" . my/test-file)
   '("m t t" . my/test-at-point)
   '("m t s" . my/test-single)
   '("m t r" . my/test-rerun)
   '("m t b" . my/bench-all)
   '("m t p" . my/bench-at-point)

   ;; Emms
   '("m u" . my/update-emms-from-mpd)
   '("m d" . emms-play-directory-tree)
   '("m p" . emms-playlist-mode-go)
   '("m h" . emms-shuffle)
   '("m x" . emms-pause)
   '("m s" . emms-stop)
   '("m b" . emms-previous)
   '("m n" . emms-next)
   '("m o" . emms-browser)

   ;; meow digits
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument))
   
  (meow-motion-define-key
   ;; Navigation
   '("m" . meow-left)
   '("M" . dired-up-directory)
   '("n" . meow-next)
   '("i" . meow-right)
   '("e" . meow-prev)
   '("W" . meow-next-word)
   '("a" . meow-insert)
   '("^" . back-to-indentation)
   '("L" . (lambda () (interactive) (meow-line 1) (meow-reverse)))
   '("l" . meow-line)
   '("h" . meow-mark-symbol)
   '("v" . meow-search)
   '("V" . meow-visit)
   '("%" . meow-block)
   '(";" . meow-reverse)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   ;; Yank
   '("y" . meow-clipboard-save)
   '("g" . meow-cancel-selection)
   ;; Jump
   '("f" . flash-jump)
   '("/" . consult-line)
   '("<escape>" . ignore))

  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("1" . meow-expand-1)
   '("2" . meow-expand-2)
   '("3" . meow-expand-3)
   '("4" . meow-expand-4)
   '("5" . meow-expand-5)
   '("6" . meow-expand-6)
   '("7" . meow-expand-7)
   '("8" . meow-expand-8)
   '("9" . meow-expand-9)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("/" . consult-line)
   '("*" . meow-visit)
   '("%" . meow-block)
   '("^" . back-to-indentation)
   '("a" . my/meow-append)
   '("A" . (lambda () (interactive) (end-of-line) (meow-insert)))
   '("b" . meow-back-word)
   '("c" . meow-change)
   '("C" . (lambda () (interactive) (meow-kill) (meow-insert)))
   '("d" . meow-clipboard-kill)
   '("e" . meow-prev)
   '("E" . meow-prev-expand)
   '("f" . flash-jump)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("m" . meow-left)
   '("M" . meow-left-expand)
   '("i" . meow-right)
   '("I" . meow-right-expand)
   '("s" . meow-append)
   '("S" . (lambda () (interactive) (beginning-of-line) (meow-insert)))
   '("j" . meow-join)
   '("l" . meow-line)
   '("L" . (lambda () (interactive) (meow-line 1) (meow-reverse)))
   '("h" . meow-mark-word)
   '("H" . meow-mark-symbol)
   '("n" . meow-next)
   '("N" . meow-next-expand)
   '("o" . meow-open-below)
   '("O" . meow-open-above)
   '("p" . my/meow-paste-below)
   '("P" . my/meow-paste-above)
   ;; '("C-v" . my/meow-paste)
   '("q" . meow-quit)
   '("Q" . kmacro-start-macro-or-insert-counter)
   '("@" . kmacro-end-or-call-macro)
   '("R" . meow-replace)
   '("r" . meow-change-char)
   '("K" . meow-pop-selection)
   '("t" . meow-till)
   '("u" . undo-tree-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-search)
   '("V" . meow-visit)
   '("w" . meow-next-word)
   '("W" . meow-next-symbol)
   '("x" . set/kill-char)
   '("X" . meow-backward-delete)
   '("y" . meow-clipboard-save)
   '("z o" . kirigami-open-fold)
   '("z O" . kirigami-open-fold-rec)
   '("z c" . kirigami-close-fold)
   '("z a" . kirigami-toggle-fold)
   '("z r" . kirigami-open-folds)
   '("z m" . kirigami-close-folds)
   '(">" . my/indent-right)
   '("<" . my/indent-left)
   '("'" . repeat)
   '("<escape>" . ignore))

  (setq meow-mode-state-list
        '((dired-mode . motion)
          (elfeed-search-mode . motion)
          (org-mode . normal)
          (elfeed-show-mode . motion)
          (erc-mode . insert)
          (vterm-mode . insert)
          (pdf-view-mode . motion)
          (calibredb-search-mode . motion)
          (dirvish-mode . motion)
          (messages-buffer-mode . motion)
          (help-mode . motion)
          (info-mode . motion)
          (occur-mode . motion)
          (pass-mode . motion)
          (grep-mode . motion)
          (compilation-mode . motion)
          (messages-buffer-mode . motion)
          (special-mode . motion))))

(use-package meow
  :straight t
  :demand t
  :config
  (meow-setup)
  (meow-global-mode 1)
  (meow-thing-register 'angle
                       '(regexp "<" ">")
                       '(regexp "<" ">"))
  (meow-thing-register 'double-quote
                       '(regexp "\"" "\"")
                       '(regexp "\"" "\""))
  (meow-thing-register 'single-quote
                       '(regexp "'" "'")
                       '(regexp "'" "'"))
  (meow-thing-register 'backtick
                       '(regexp "`" "`")
                       '(regexp "`" "`"))

  (setq meow-cursor-type-insert 'box)
  (setq meow-char-thing-table
        '((?\( . round)
          (?\[ . square)
          (?\{ . curly)
          (?\< . angle)
          (?\" . double-quote)
          (?\' . single-quote)
          (?\` . backtick)
          (?e . symbol)
          (?w . window)
          (?b . buffer)
          (?p . paragraph)
          (?l . line)
          (?d . defun))))

(defun set/kill-char ()
  "Kills a character adding it to killring, like x in vim"
  (interactive)
  (kill-region (point) (1+ (point))))

;; Tab behaviour
(setq tab-always-indent t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(defun my/meow-append ()
  (interactive)
  (forward-char 1)
  (meow-append))

(defun my/meow-paste-below ()
  (interactive)
  (end-of-line)
  (newline)
  (meow-yank))

(defun my/meow-paste-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (meow-yank))

(defun my/indent-right ()
  "Indent region or line right."
  (interactive)
  (if (use-region-p)
      (indent-rigidly (region-beginning) (region-end) tab-width)
    (indent-rigidly (line-beginning-position) (line-end-position) tab-width)))

(defun my/indent-left ()
  "Indent region or line left."
  (interactive)
  (if (use-region-p)
     (indent-rigidly (region-beginning) (region-end) (- tab-width))
    (indent-rigidly (line-beginning-position) (line-end-position) (- tab-width))))

;;Save all buffers
(defun my/save-all-buffers ()
  "Save all modified buffers without prompting."
  (interactive)
  (save-some-buffers t))

;; File path yanking
(defun my/yank-buffer-path (&optional root)
  "Copy current buffer's file path to kill ring."
  (interactive)
  (let ((filename (or (and (derived-mode-p 'dired-mode)
                           (dired-get-file-for-visit))
                      (buffer-file-name))))
    (if filename
        (let ((path (if root
                        (file-relative-name filename root)
                      (abbreviate-file-name filename))))
          (kill-new path)
          (message "Copied: %s" path))
      (message "Buffer is not visiting a file"))))

;; Tabs
(global-set-key (kbd "C-<tab>")   #'tab-next)
(global-set-key (kbd "C-S-<tab>") #'tab-previous)

;; Eval region
(global-set-key (kbd "C-x C-r") #'eval-region)

;; Set register jumppoints
(global-set-key (kbd "C-c M") #'consult-register-store)
(global-set-key (kbd "C-c J") #'consult-register)

;; Window movement
;; (global-set-key (kbd "C-w") #'backward-kill-word)
(global-set-key (kbd "C-<left>")  #'windmove-left)
(global-set-key (kbd "C-<right>") #'windmove-right)
(global-set-key (kbd "C-<down>")  #'windmove-down)
(global-set-key (kbd "C-<up>")    #'windmove-up)

(global-set-key (kbd "S-<right>") (lambda () (interactive)
                                    (if (window-in-direction 'left)
                                        (shrink-window-horizontally 5)
                                      (enlarge-window-horizontally 5))))
(global-set-key (kbd "S-<left>")  (lambda () (interactive)
                                    (if (window-in-direction 'right)
                                        (shrink-window-horizontally 5)
                                      (enlarge-window-horizontally 5))))
(global-set-key (kbd "S-<up>")    (lambda () (interactive)
                                    (if (window-in-direction 'below)
                                        (shrink-window 2)
                                      (enlarge-window 2))))
(global-set-key (kbd "S-<down>")  (lambda () (interactive)
                                    (if (window-in-direction 'above)
                                        (shrink-window 2)
                                      (enlarge-window 2))))

;; Zoom
(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)



;; Save
;; (global-set-key (kbd "C-v") #'clipboard-yank)
;; (define-key minibuffer-local-map (kbd "C-v") #'yank)
(global-set-key (kbd "C-s") #'save-buffer)
(global-set-key (kbd "C-r") #'undo-tree-redo)

(defun set/increment-number (arg)
  "Increment number at point by ARG."
  (interactive "p")
  (save-excursion
    (skip-chars-backward "0-9")
    (when (looking-at "[0-9]+")
      (replace-match
       (number-to-string (+ arg (string-to-number (match-string 0))))))))

(defun my/decrement-number (arg)
  "Decrement number at point by ARG."
  (interactive "p")
  (my/increment-number (- arg)))

(global-set-key (kbd "C-S-<up>") #'my/increment-number)
(global-set-key (kbd "C-S-<down>") #'my/decrement-number)

(defun my/replace-string-smart (from to)
  "Replace string from point to end, or within region if active."
  (interactive "sReplace: \nsReplace %s with: ")
  (let ((start (if (use-region-p) (region-beginning) (point)))
        (end (if (use-region-p) (region-end) (point-max))))
    (replace-string from to nil start end)))

(global-set-key (kbd "M-#") #'my/replace-string-smart)

;; Reload config
(defun my/reload-config ()
  (interactive)
  (load-file user-init-file)
  (message "Config reloaded."))
(global-set-key (kbd "C-c r") #'my/reload-config)

(provide 'meow-setup)
;;; meow-setup.el ends here
