;; projects.el
;; -*- lexical-binding: t -*-

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

;;Persisted window
(defvar my/project-desktop-dir
  (expand-file-name "project-desktops" user-emacs-directory)
  "Directory where per-project desktop files are stored.")

(defun my/project-desktop-file (root)
  "Return the desktop file path for project ROOT."
  (expand-file-name
   (concat (file-name-nondirectory (directory-file-name root)) ".desktop")
   my/project-desktop-dir))

(defun my/project-save-desktop ()
  "Save desktop for the current project."
  (when-let* ((proj (project-current))
              (root (project-root proj)))
    (make-directory my/project-desktop-dir t)
    (let ((desktop-dir (my/project-desktop-file root))
          (desktop-base-file-name "emacs.desktop")
          (desktop-base-lock-name "emacs.desktop.lock"))
      (make-directory (file-name-directory desktop-dir) t)
      (desktop-save (file-name-directory desktop-dir)))))

(defun my/project-load-desktop (root)
  "Load desktop for project ROOT if it exists."
  (let* ((desktop-dir (file-name-directory (my/project-desktop-file root)))
         (desktop-file (expand-file-name "emacs.desktop" desktop-dir)))
    (if (file-exists-p desktop-file)
        (desktop-read desktop-dir)
      ;; No saved desktop, just open dired
      (dired root))))


;; Update the project switch function to trigger the hook
(defun my/project-switch-slot (n)
  "Switch to the project in slot N."
  (let ((root (aref my/project-slots n)))
    (if (null root)
        (message "No project in slot %d" n)
      (my/project-save-desktop)
      (let ((default-directory root))
        (my/centaur-tabs-hide-non-project-tabs)
        (my/project-load-desktop root)))))

(defun my/project-switch-with-tabs (project)
  "Switch to PROJECT, persisting buffers and window config."
  (interactive (list (project-prompt-project-dir)))
  ;; Save current project state
  (my/project-save-desktop)
  ;; Switch project
  (project-switch-project project)
  (let ((root (project-root (project-current t))))
    ;; Hide other project tabs
    (my/centaur-tabs-hide-non-project-tabs)
    ;; Restore new project state
    (my/project-load-desktop root)))

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

(defvar my/project-slots (make-vector 10 nil)
  "Vector of project roots assigned to slots 0-9.")

(defun my/project-assign-slot (n)
  "Assign current project to slot N (0-9)."
  (interactive "nAssign to slot (0-9): ")
  (if-let (root (project-root (project-current t)))
      (progn
        (aset my/project-slots n root)
        (message "Slot %d → %s" n root))
    (message "Not in a project")))

(defun my/project-switch-slot (n)
  "Switch to the project in slot N."
  (interactive "nSwitch to slot (0-9): ")
  (if-let (root (aref my/project-slots n))
      (my/project-switch-slot root)
    (message "No project in slot %d" n)))

;; Bind C-c 1 through C-c 9
(defun my/make-project-switcher (n)
  "Return a command that switches to project slot N."
  (cons 'lambda `(() (interactive) (my/project-switch-slot ,n))))

(dotimes (i 9)
  (keymap-global-set
   (format "C-c %d" (1+ i))
   (my/make-project-switcher (1+ i))))

;; Assign current project to a slot
(keymap-global-set "C-c 0" #'my/project-assign-slot)

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

(defun my/project-find-file (&optional depth)
  (interactive)
  (let* ((depth (or depth 3))
         (root (project-root (project-current t)))
         (cmd (if (executable-find "fd")
                  (format "fd --type f --max-depth %d" depth)  ; no root = relative output
                (format "find . -maxdepth %d -type f" depth)))
         (default-directory root)  ; run the command from the root
         (files (split-string (shell-command-to-string cmd) "\n" t))
         (table (lambda (str pred action)
                  (if (eq action 'metadata)
                      '(metadata (category . file))
                    (complete-with-action action files str pred))))
         (selected (completing-read "Find file: " table nil t)))
    (find-file (expand-file-name selected root)))) 

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

(add-hook 'kill-emacs-hook #'my/project-save-desktop)

(run-with-timer 0 300 #'my/project-save-desktop)

(provide 'projects)
