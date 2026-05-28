;;; workspaces.el --- Description -*- lexical-binding: t; -*-

;; Easysession
(use-package easysession
  :ensure t
  :custom
  (easysession-save-interval 60)
  :init
  (easysession-setup))

;;; Faces
(defface +workspace-tab-face
  '((t :inherit shadow))
  "Face for inactive workspace tabs.")

(defface +workspace-tab-selected-face
  '((t :inherit (bold default)))
  "Face for the active workspace tab.")

;;; Backend: bufferlo for real isolation
(use-package bufferlo
  :ensure t
  :demand t
  :init
  (setq bufferlo-advise-calls nil)
  :config
  (bufferlo-mode 1)
  (bufferlo-anywhere-mode -1))

;;; Helpers
(defun +workspace--current-name ()
  (alist-get 'name (tab-bar--current-tab)))

(defun +workspace--names ()
  (mapcar (lambda (tab) (alist-get 'name tab)) (tab-bar-tabs)))

;;; Display
(defun +workspace--format-tab (index name is-current)
  (let* ((label (format "[%d] %s" (1+ index) name))
         (text  (if is-current
                    (format "(%s) " label)
                  (format " %s  " label)))
         (face  (if is-current
                    '+workspace-tab-selected-face
                  '+workspace-tab-face)))
    (propertize text 'face face)))

(defun +workspace/display ()
  "Show workspace bar in the echo area."
  (interactive)
  (let* ((tabs    (tab-bar-tabs))
         (current (tab-bar--current-tab)))
    (message "%s"
             (mapconcat
              (lambda (tab)
                (+workspace--format-tab
                 (seq-position tabs tab)
                 (alist-get 'name tab)
                 (eq tab current)))
              tabs ""))))

(dolist (fn '(tab-bar-new-tab
              tab-bar-close-tab
              tab-bar-switch-to-tab
              tab-bar-select-tab
              tab-bar-rename-tab))
  (advice-add fn :after (lambda (&rest _) (+workspace/display))))

;;; Core operations
(defun +workspace/new (&optional name)
  "Create a new blank workspace named NAME."
  (interactive (list (read-string "Workspace name: "
                                  (format "" (1+ (length (tab-bar-tabs)))))))
  (let ((name (or name (format "" (1+ (length (tab-bar-tabs)))))))
    (if (member name (+workspace--names))
        (message "+workspace: '%s' already exists" name)
      (let ((tab-bar-new-tab-choice (lambda () (get-buffer-create "*scratch*"))))
        (tab-bar-new-tab)
        (tab-bar-rename-tab name)
        (delete-other-windows)))))

(defun +workspace/switch-to ()
  "Switch to workspace via completing-read."
  (interactive)
  (let ((name (completing-read "Switch to workspace: "
                               (+workspace--names)
                               nil t)))
    (tab-bar-switch-to-tab name)))

(defun +workspace/delete ()
  "Close current workspace. bufferlo handles buffer cleanup."
  (interactive)
  (if (<= (length (tab-bar-tabs)) 1)
      (message "+workspace: can't delete the last workspace")
    ;; Kill buffers that belong only to this tab
    (let ((local-bufs (bufferlo-buffer-list)))
      (tab-bar-close-tab)
      (dolist (buf local-bufs)
        (when (and (buffer-live-p buf)
                   (not (get-buffer-window buf t))
                   ;; Don't kill if it's now local to the new current tab
                   (not (bufferlo-local-buffer-p buf)))
          (kill-buffer buf))))))

(defun +workspace/rename (name)
  "Rename the current workspace."
  (interactive (list (read-string "Rename workspace to: "
                                  (+workspace--current-name))))
  (tab-bar-rename-tab name))

;;; Project integration
(defun +workspace/switch-to-project ()
  "Open project in a dedicated workspace; switch if it already exists."
  (interactive)
  (let* ((dir  (project-prompt-project-dir))
         (name (file-name-nondirectory (directory-file-name dir))))
    (if (member name (+workspace--names))
        (tab-bar-switch-to-tab name)
      (let ((tab-bar-new-tab-choice (lambda () (get-buffer-create "*scratch*"))))
        (tab-bar-new-tab)
        (tab-bar-rename-tab name)
        (delete-other-windows)
        (let ((default-directory dir))
          (my/project-find-file))))))

;;; Consult integration
(with-eval-after-load 'consult
  (defvar +workspace-consult-source-buffer
    `(:name     "Workspace"
                :narrow   ?w
                :category buffer
                :face     consult-buffer
                :history  buffer-name-history
                :state    ,#'consult--buffer-state
                :default  t
                :items    ,(lambda ()
                             (consult--buffer-query
                              :predicate #'bufferlo-local-buffer-p
                              :sort      'visibility
                              :as        #'buffer-name))))

  (defvar +workspace-consult-source-other-buffer
    `(:name     "Other Workspaces"
                :narrow   ?o
                :hidden   t
                :category buffer
                :face     consult-buffer
                :history  buffer-name-history
                :state    ,#'consult--buffer-state
                :items    ,(lambda ()
                             (consult--buffer-query
                              :predicate (lambda (b)
                                           (and (not (bufferlo-local-buffer-p b))
                                                (not (string-prefix-p " " (buffer-name b)))))
                              :sort      'visibility
                              :as        #'buffer-name))))

  (setq consult-buffer-sources
        '(+workspace-consult-source-buffer
          +workspace-consult-source-other-buffer)))

;; Projects
(require 'project)

(setq project-vc-extra-root-markers
      '(".projectile" "package.json" "Makefile" "pyproject.toml" "setup.py" "compile_commands.json"))

(setq project-list-file (expand-file-name "projects" user-emacs-directory))

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

(setq project-list-file (expand-file-name "projects" user-emacs-directory))

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

;;; Bootstrap
(setq tab-bar-show nil)

;;; Keybindings

(when (featurep 'consult)
  (setq consult-buffer-sources
        '(+workspace-consult-source-buffer
          +workspace-consult-source-other-buffer)))

;; Reduce noise

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


(provide 'workspaces)
;;; workspaces.el ends here
