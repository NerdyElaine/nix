;;; org-config.el --- Org-mode + org-roam + denote configuration

(use-package org
  :straight t
  :defer t
  :config
  (setq org-directory "~/orgfiles/")
 
  (setq org-startup-indented t
        org-startup-folded 'content
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-return-follows-link t
        org-log-done 'time
        org-log-into-drawer t)

  (setq org-preview-latex-default-process 'dvisvgm)

  (setq org-latex-preview-live t)

  (setq org-latex-preview-scale 1.5)

  (setq org-latex-preview-live-debounce 0.5)
 
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|"
                    "DONE(d!)" "CANCELLED(c@)")))
 
  (setq org-refile-targets '((nil :maxlevel . 3)
                              (org-agenda-files :maxlevel . 3)))
  (setq org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil)
  (setq org-agenda-files (list org-directory))
 
  ;; Archive
  (add-hook 'org-mode-hook
          (lambda ()
            (when (fboundp 'org-latex-preview-auto-mode)
              (org-latex-preview-auto-mode))))
  (setq org-archive-location "~/orgfiles/archive/%s_archive::"))

(use-package org-roam
  :straight t
  :after org
  :custom
  (org-roam-directory org-directory)          
  (org-roam-completion-everywhere t)          
  (org-roam-db-autosync-mode t)
  
  (org-roam-node-display-template
   (concat "${title:*} "
           (propertize "${tags:20}" 'face 'org-tag)))
  :bind
  (("C-c n f" . org-roam-node-find)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n g" . org-roam-graph)
   ("C-c n b" . org-roam-buffer-toggle)
   ("C-c n c" . org-roam-capture)
   ("C-c n t" . org-roam-tag-add)
   ("C-c n r" . org-roam-ref-add))
 
  :config
  (org-roam-db-autosync-mode))
(setq org-roam-capture-templates
      '(("p" "permanent note" plain
         (file "~/nix/home/custom/emacs/templates/permanent.org")
         :target (file+head "notes/permanent/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("l" "literature note" plain
         (file "~/nix/home/custom/emacs/templates/literature.org")
         :target (file+head "notes/literature/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("m" "math note" plain
         (file "~/nix/home/custom/emacs/templates/math.org")
         :target (file+head "notes/math/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("i" "index / topic" plain
         (file "~/nix/home/custom/emacs/templates/index.org")
         :target (file+head "notes/index/${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("f" "fleeting note" plain
         (file "~/nix/home/custom/emacs/templates/fleeting.org")
         :target (file+head "notes/fleeting/${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)))

 (setq org-roam-dailies-directory "notes/dailies/")

(setq org-roam-dailies-capture-templates
  '(("d" "default" plain
     "#+filetags: :daily:\n\n* TODO Tasks\n\n* Thoughts\n\n* Notes\n\n* Ideas\n\n* Links"
     :target (file+head "%<%Y-%m-%d>.org"
                        "#+title: %<%Y-%m-%d>\n")
     :unnarrowed t)))

(use-package denote
  :after org
  :custom
  (denote-directory org-directory)
 
  (denote-file-type 'org)
  (denote-prompts '(title keywords))
  (denote-known-keywords '("journal" "meeting" "reference" "project" "fleeting"))
  (denote-infer-keywords t)
  (denote-sort-keywords t)
 
  (denote-rename-buffer-mode t)
 
  (denote-org-front-matter
   "#+title:      %s
#+date:       %s
#+filetags:   %s
#+identifier: %s
\n")
 
  :bind
  (("C-c d n" . denote)
   ("C-c d N" . denote-type)
   ("C-c d d" . denote-date)
   ("C-c d s" . denote-subdirectory)
   ("C-c d t" . denote-template)
   ("C-c d r" . denote-rename-file)
   ("C-c d R" . denote-rename-file-using-front-matter)
   ("C-c d l" . denote-link)
   ("C-c d L" . denote-add-links)
   ("C-c d b" . denote-backlinks)
   ("C-c d f" . denote-find-file)
   ("C-c d g" . denote-grep))
 
  :config
  ;; Use denote links in org buffers
  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
                 '("j" "Journal (denote)" plain
                   (function denote-journal-extras-new-or-existing-entry)
                   "%i%?"
                   :empty-lines-before 1))))

(use-package denote-org
  :straight t
  :ensure t
  :after denote
  :config
  (setq denote-org-store-link-to-heading t)) 

(with-eval-after-load 'org-roam
  (defun my/org-roam-denote-slug-as-id ()
    "Use denote identifier (timestamp) as org-roam node ID fallback."
    (when-let* ((file (buffer-file-name))
                (id (denote-retrieve-filename-identifier file)))
      id))
 

  (defun my/denote-and-roam-link (title keywords)
    (interactive
     (list (denote-title-prompt)
           (denote-keywords-prompt)))
    (let ((file (denote--file-extension (denote-directory))))
      (denote title keywords)
      (org-roam-node-insert (lambda () (org-roam-node-at-point)))))
 
  (bind-key "C-c n d" #'my/denote-and-roam-link))

(with-eval-after-load 'consult
  (defun my/consult-notes ()
    (interactive)
    (consult--multi
     `((:name "Roam nodes"
        :narrow ?r
        :category 'org-roam-node
        :action ,(lambda (c) (org-roam-node-visit (org-roam-node-from-title-or-alias c)))
        :items ,(lambda ()
                  (mapcar #'org-roam-node-title
                          (org-roam-node-list))))
       (:name "Denote files"
        :narrow ?d
        :category 'file
        :action ,#'find-file
        :items ,(lambda () (denote-directory-files nil nil t))))
     :prompt "Notes: "
     :sort nil))
 
  (bind-key "C-c n s" #'my/consult-notes))

(use-package org-modern
  :straight t
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "✸" "✿")
        org-modern-table nil            
        org-modern-keyword "‣"
        org-modern-tag t))
 
(use-package org-appear
  :straight t
  :after org
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks t
        org-appear-autoentities t
        org-appear-autokeywords t))

(use-package org-roam-ui
  :straight t
  :ensure t
  :defer t
  :commands (org-roam-ui-mode org-roam-ui-open)
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))


(provide 'org-config)
 ;;; end of org-config.el
