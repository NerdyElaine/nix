;;; dired-config.el --- Dired/dirvish config -*- lexical-binding: t; -*-

(use-package dired
  :straight nil
  :ensure nil
  :custom
  (insert-directory-program "/run/current-system/sw/bin/gls")
  (dired-listing-switches "-lAh --group-directories-first --no-group")
  (dired-dwin-target t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (delete-by-moving-to-trash t))

(use-package dirvish
  :straight t
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-default-layout '(1 0.11 0.55))
  (dirvish-layout-recipes
   '((0 0    0.4)
     (0 0    0.8)   
     (1 0.08 0.5)   
     (1 0.11 0.55)  
     (1 0.15 0.6)))
  (dirvish-preview-dispatchers
   '(disable
     vc-diff                              
     bat               
     gif               
     image             
     video              
     epub              
     archive           
     pdf-preface)) 

  (dirvish-preview-disabled-exts
   '("iso" "bin" "exe" "dmg" "tar" "gz" "bz2" "xz" "zst"))
  (dirvish-header-line-height '(25 . 35))
  (dirvish-header-line-format
   '(:left  (path)                         
    :right (free-space)))

  (dirvish-mode-line-height '(20 . 30))
  (dirvish-mode-line-format
   '(:left  (sort file-time symlink)
            :right (omit yank index)))

    (dirvish-attributes
   '(nerd-icons       
     vc-state          
     git-msg           
     file-time         
     file-size         
     collapse))

    (dirvish-large-file-threshold (* 10 1024 1024))

    (dirvish-subtree-state-style 'nerd)

    (dirvish-fd-switches "--hidden --no-ignore")

    (setq dirvish-quick-access-entries
        `(("h" "~/"                          "Home")
          ("d" "~/Downloads/"                "Downloads")
          ("p" "~/dev/"                      "Projects")
          ("c" "~/nix/"                      "Nix")
          ("e" "~/nix/home/custom/emacs/"    "Emacs Config")
          ("r" "/"                           "Root")))
    
    (setq dirvish-emerge-groups
        '(("Recent files"    (predicate . dirvish-emerge--pred-recent))
          ("Directories"     (predicate . dirvish-emerge--pred-directory))
          ("Executables"     (predicate . dirvish-emerge--pred-executable))
          ("Documents"       (extensions "pdf" "tex" "org" "md" "rst" "txt"))
          ("Source code"     (extensions "el" "py" "rs" "c" "cpp" "h" "hpp"
                                         "hs" "js" "ts" "jsx" "tsx" "nix"
                                         "go" "rb" "java" "sh" "bash"))
          ("Images"          (extensions "jpg" "jpeg" "png" "gif" "svg" "webp" "avif"))
          ("Media"           (extensions "mp4" "mkv" "mov" "mp3" "flac" "wav" "ogg"))
          ("Archives"        (extensions "zip" "tar" "gz" "bz2" "xz" "zst" "7z" "rar"))))
    (setq dirvish-yank-keys nil)
  (define-key dirvish-mode-map (kbd "m")       #'dired-up-directory)
  (define-key dirvish-mode-map (kbd "l")       #'dired-find-file)
  (define-key dirvish-mode-map (kbd "n")       #'dired-next-line)
  (define-key dirvish-mode-map (kbd "e")       #'dired-previous-line)
  (define-key dirvish-mode-map (kbd "<left>")  #'dired-up-directory)
  (define-key dirvish-mode-map (kbd "<right>") #'dired-find-file)
  (define-key dirvish-mode-map (kbd "<down>")  #'dired-next-line)
  (define-key dirvish-mode-map (kbd "<up>")    #'dired-previous-line)
  (define-key dirvish-mode-map (kbd "TAB")     #'dirvish-subtree-toggle)
  (define-key dirvish-mode-map (kbd "S-TAB")   #'dirvish-subtree-toggle)
  (define-key dired-mode-map (kbd "h")         #'dired-mark)
  (define-key dired-mode-map (kbd "i")         #'wdired-change-to-wdired-mode)
  (define-key dired-mode-map (kbd "u")         #'dired-unmark)
  (define-key dired-mode-map (kbd "D")         #'dired-flag-file-deletion)
  (define-key dired-mode-map (kbd "R")         #'dired-do-rename)
  (define-key dired-mode-map (kbd "C")         #'dired-do-copy)
  (define-key dired-mode-map (kbd "q")         #'dirvish-quit)
  (define-key dired-mode-map (kbd ".")         #'dired-omit-mode)
  (define-key dired-mode-map (kbd "G")         #'revert-buffer)
  )

(defun my-dired-filter-apple-sharpener ()
  (when (and (buffer-live-p (current-buffer))
             (derived-mode-p 'dired-mode))
    (let ((inhibit-read-only t))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "^.*AppleSharpener.*\n" nil t)
          (replace-match ""))))))

(add-hook 'dired-after-readin-hook #'my-dired-filter-apple-sharpener)

(with-eval-after-load 'dirvish
  (add-hook 'dirvish-after-revert-hook #'my-dired-filter-apple-sharpener))

(provide 'dired-config)

;;; dired-config ends here
