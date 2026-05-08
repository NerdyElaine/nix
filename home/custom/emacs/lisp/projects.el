;; projects.el

(require 'project)

(setq project-vc-extra-root-markers
      '(".projectile" "package.json" "Makefile" "pyproject.toml" "setup.py" "compile_commands.json"))

(setq project-list-file (expand-file-name "projects" user-emacs-directory))

(defun my/centaur-tabs-project-buffer-p (buf)
  "Return t if BUF belongs to the current project."
  (when-let* ((proj (project-current))
              (root (file-truename (project-root proj)))
              (file (buffer-file-name buf)))
    (string-prefix-p root (file-truename file))))

(defun my/centaur-tabs-hide-non-project-tabs ()
  "Hide all tabs not belonging to the current project."
  (when-let* ((proj (project-current))
              (root (file-truename (project-root proj)))
              (group (file-name-nondirectory (directory-file-name root))))
    ;; Switch to the group first
    (centaur-tabs-switch-group group)
    ;; Then hide buffers from other groups
    (dolist (buf (buffer-list))
      (let ((file (buffer-file-name buf)))
        (when (and file
                   (not (string-prefix-p root (file-truename file))))
          (centaur-tabs-hide-tab buf))))))

(defun my/centaur-tabs-restore-all-tabs ()
  "Restore all hidden tabs (call when you want everything back)."
  (dolist (buf (buffer-list))
    (centaur-tabs-show-tab buf)))

;; Hook into project switching
(add-hook 'project-switch-project-hook #'my/centaur-tabs-hide-non-project-tabs)

;; Update the project switch function to trigger the hook
(defun my/project-switch-with-tabs (project)
  "Switch to PROJECT, showing only its tabs in centaur-tabs."
  (interactive (list (project-prompt-project-dir)))
  (project-switch-project project)
  ;; hook fires automatically, but also handle the empty project case
  (let* ((root (project-root (project-current t)))
         (project-bufs (cl-remove-if-not
                        (lambda (buf)
                          (when-let (file (buffer-file-name buf))
                            (string-prefix-p root (file-truename file))))
                        (buffer-list))))
    (unless project-bufs
      (call-interactively
       (if (executable-find "fd")
           #'my/project-find-file-fd
         #'project-find-file)))))

(keymap-set project-prefix-map "p" #'my/project-switch-with-tabs)

;; Also hide non-project tabs when opening any file
(add-hook 'find-file-hook #'my/centaur-tabs-hide-non-project-tabs)

;; Convenience: restore all tabs if you want out of project mode
(keymap-set project-prefix-map "R" #'my/centaur-tabs-restore-all-tabs)

(defun my/centaur-tabs-hide-non-project-tabs ()
  "Hide all tabs not belonging to the current project.
   Always keeps special buffers (scratch, messages, etc) visible."
  (when-let* ((proj (project-current))
              (root (file-truename (project-root proj)))
              (group (file-name-nondirectory (directory-file-name root))))
    (centaur-tabs-switch-group group)
    (dolist (buf (buffer-list))
      (let ((file (buffer-file-name buf))
            (name (buffer-name buf)))
        (cond
         ;; Always keep special buffers
         ((string-match-p "^\\*" name) nil)
         ;; Hide file buffers from other projects
         ((and file (not (string-prefix-p root (file-truename file))))
          (centaur-tabs-hide-tab buf)))))))

(defun my/project-try-marker (dir)
  "Return a project for DIR if it contains a known root marker."
  (let ((markers '(".projectile" "package.json" "Cargo.toml"
                   "pyproject.toml" "setup.py" "Makefile"
                   "compile_commands.json" ".project")))
    (cl-some (lambda (marker)
               (when (locate-dominating-file dir marker)
                 (cons 'transient (locate-dominating-file dir marker))))
             markers)))

(add-hook 'project-find-functions #'my/project-try-marker)

;; Manually add a single directory
(defun my/project-add (dir)
  "Register DIR as a project. Works even without a git repo."
  (interactive "DAdd project directory: ")
  (let ((dir (file-truename (expand-file-name dir))))
    ;; Drop a marker file if no other marker exists
    (unless (cl-some (lambda (f) (file-exists-p (expand-file-name f dir)))
                     '(".git" ".projectile" "package.json" "Cargo.toml"))
      (when (yes-or-no-p (format "No marker found in %s. Create .project file? " dir))
        (write-region "" nil (expand-file-name ".project" dir))))
    (project-remember-project (cons 'transient dir))
    (message "Registered project: %s" dir)))

;; Bulk-add all subdirectories of a parent directory
(defun my/project-add-all-under (parent)
  "Register every immediate subdirectory of PARENT as a project."
  (interactive "DRegister all projects under: ")
  (let ((dirs (cl-remove-if-not
               #'file-directory-p
               (directory-files parent t "^[^.]")))  ; skip dotfiles
        (count 0))
    (dolist (dir dirs)
      (project-remember-project (cons 'transient dir))
      (cl-incf count))
    (message "Registered %d projects under %s" count parent)))

;; Remove a project from the list
(defun my/project-remove (project)
  "Forget a registered project."
  (interactive (list (project-prompt-project-dir)))
  (project-forget-project project)
  (message "Removed project: %s" project))

(use-package consult
  :ensure t
  :bind (:map project-prefix-map
         ("s" . my/project-ripgrep)   ; C-x p s → rg
         ("f" . consult-project-buffer))
  :config
  (setq consult-project-function (lambda (_may-prompt) (project-root (project-current)))))

(defun my/project-ripgrep ()
  "Run ripgrep in the current project root."
  (interactive)
  (let ((default-directory (project-root (project-current t))))
    (consult-ripgrep default-directory)))

(defvar my/project-compile-commands (make-hash-table :test #'equal))

(defun my/project-compile ()
  "Run a compile command, remembered per project."
  (interactive)
  (let* ((root (project-root (project-current t)))
         (saved (gethash root my/project-compile-commands))
         (cmd (read-shell-command "Compile command: " (or saved "make "))))
    (puthash root cmd my/project-compile-commands)
    (let ((default-directory root))
      (compile cmd))))

(keymap-set project-prefix-map "C" #'my/project-compile)

(defun my/project-find-file-fd ()
  "Find project file using fd for speed."
  (interactive)
  (let* ((root (project-root (project-current t)))
         (fd-bin (or (executable-find "fd")
                     (executable-find "fdfind")
                     (error "Neither fd nor fdfind found in PATH")))
         ;; cd into root first, then run fd without a path argument
         ;; that way --strip-cwd-prefix works correctly
         (default-directory root)
         (cmd (format "%s --type f --color never --strip-cwd-prefix"
                      fd-bin))
         (files (split-string (shell-command-to-string cmd) "\n" t "[ \t]+")))
    (if (null files)
        (message "fd returned no files in %s" root)
      (let ((file (completing-read "Find file: " files nil t)))
        (find-file (expand-file-name file root))))))

(defun my/project-kill-buffers ()
  "Kill all buffers belonging to current project, with confirmation."
  (interactive)
  (let ((name (project-root (project-current t))))
    (when (yes-or-no-p (format "Kill all buffers in %s? " name))
      (project-kill-buffers t))))

(keymap-set project-prefix-map "K" #'my/project-kill-buffers)

(defun my/filter-applesharpener (output)
  "Filter AppleSharpener noise from process output."
  (replace-regexp-in-string
   ".*\\[AppleSharpener\\].*\n?" "" output))

;; Filter from shell command output
(advice-add 'shell-command-to-string :filter-return
            #'my/filter-applesharpener)

;; Filter from *Messages* buffer
(defun my/filter-messages-buffer (&rest _)
  (with-current-buffer "*Messages*"
    (let ((inhibit-read-only t))
      (goto-char (point-min))
      (flush-lines "\\[AppleSharpener\\]"))))

(add-hook 'messages-buffer-mode-hook #'my/filter-messages-buffer)

;; Filter from minibuffer messages
(defvar my/original-message (symbol-function 'message))

(defun my/filtered-message (format-string &rest args)
  (when format-string
    (let ((msg (apply #'format format-string args)))
      (unless (string-match-p "\\[AppleSharpener\\]" msg)
        (apply my/original-message format-string args)))))

(advice-add 'message :around
            (lambda (orig fmt &rest args)
              (when fmt
                (let ((msg (apply #'format fmt args)))
                  (unless (string-match-p "\\[AppleSharpener\\]" msg)
                    (apply orig fmt args))))))

(provide 'projects)
