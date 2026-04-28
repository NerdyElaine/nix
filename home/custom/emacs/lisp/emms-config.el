;;; emms-config.el --- Description -*- lexical-binding: t; -*-
;;; Code:

(use-package emms
  :straight t
  :defer t
  :commands (emms
             emms-browser
             emms-playlist-mode-go
             emms-pause
             emms-stop
             emms-next
             emms-previous
             emms-shuffle)
  :init
  (setq emms-source-file-default-directory "~/Music"
        emms-playlist-buffer-name "*Music*"
        emms-info-asynchronously t
        emms-browser-default-browse-type 'info-album)

  :config
  (emms-all)
  (emms-mode-line-mode 1)
  (emms-playing-time-mode 1)

  (defun my/emms-browser-covers-mpd (path size)
  "Resolve cover art for MPD tracks whose name may be a relative URI."
  (let ((full-path (if (file-name-absolute-p path)
                       path
                     (expand-file-name path emms-player-mpd-music-directory))))
    (emms-browser-cache-thumbnail-async full-path size)))
  
  (setq emms-browser-covers 'my-emms-covers
        emms-browser-thumbnail-small-size 64
        emms-browser-thumbnail-medium-size 128
        emms-browser-thumbnail-filenames '("cover" "folder" "album" "front" "art")
        emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)

  ;; MPD — sole player
  (require 'emms-player-mpd)
  (setq emms-player-mpd-server-name "127.0.0.1"
        emms-player-mpd-server-port "6600"
        emms-player-mpd-music-directory (expand-file-name "~/Music")
        emms-player-list '(emms-player-mpd))

  (setq emms-player-mpd-supported-regexp
        (regexp-opt '(".mp3" ".flac" ".ogg" ".m4a" ".aac" ".wav" ".wv" ".opus")))

  (add-to-list 'emms-info-functions 'emms-info-mpd)

  (defun my/safe-mpd-connect ()
    "Connect to MPD only if reachable, fail silently otherwise."
    (condition-case nil
        (emms-player-mpd-connect)
      (error (message "[emms] MPD not running, skipping connect"))))

  (run-with-timer 0.1 nil #'my/safe-mpd-connect)

  ;; Everforest faces
  (set-face-attribute 'emms-browser-artist-face nil
                      :foreground "#a7c080" :height 1.2 :weight 'bold)
  (set-face-attribute 'emms-browser-album-face nil
                      :foreground "#dbbc7f" :height 1.05)
  (set-face-attribute 'emms-browser-track-face nil
                      :foreground "#d3c6aa" :height 1.0)
  (set-face-attribute 'emms-playlist-track-face nil
                      :foreground "#d3c6aa" :height 1.0)
  (set-face-attribute 'emms-playlist-selected-face nil
                      :foreground "#a7c080" :weight 'bold)

  ;; Browser keybindings
  (define-key emms-browser-mode-map (kbd "RET") #'emms-browser-add-tracks-and-play)
  (define-key emms-browser-mode-map (kbd "SPC") #'emms-pause)
  (define-key emms-browser-mode-map (kbd "n")   #'emms-next)
  (define-key emms-browser-mode-map (kbd "p")   #'emms-previous)
  (define-key emms-browser-mode-map (kbd "s")   #'emms-stop)
  (define-key emms-browser-mode-map (kbd "r")   #'emms-shuffle)
  (define-key emms-browser-mode-map (kbd "u")   #'my/update-emms-from-mpd)
  (define-key emms-browser-mode-map (kbd "c")   #'my/emms-show-cover)
  (define-key emms-browser-mode-map (kbd "q")   #'quit-window)
  (define-key emms-browser-mode-map (kbd "TAB") #'emms-browser-toggle-subitems)
  (define-key emms-browser-mode-map (kbd "1")   #'emms-browser-display-by-artist)
  (define-key emms-browser-mode-map (kbd "2")   #'emms-browser-display-by-album)
  (define-key emms-browser-mode-map (kbd "3")   #'emms-browser-display-by-genre)
  (define-key emms-browser-mode-map (kbd "4")   #'emms-browser-display-by-year)

  (add-hook 'emms-player-started-hook #'emms-notify-song-change-with-artwork))

;; HELPER FUNCTIONS

(defun my-emms-covers (dir type)
	"Choose album cover in DIR deppending on TYPE.
Small cover should be less than 80000 bytes.
Medium - less than 120000 bytes."
	(let* ((pics (directory-files-and-attributes
		      dir t "\\.\\(jpe?g\\|png\\|gif\\|bmp\\)$" t))
	       (pic (car pics))
	       (pic-size (nth 8 pic)))
	  (let (temp)
	    (cond
	     ((eq type 'small)
	      (while (setq temp (cadr pics))
		(let ((temp-size (nth 8 temp)))
		  (if (< temp-size pic-size)
		      (setq pic temp
			    pic-size temp-size)))
		(setq pics (cdr pics)))
	      (if (<= (or pic-size 80001) 80000)
		  (car pic)))
	     ((eq type 'medium)
	      (if (and pic (setq temp (cadr pics)))
		  (progn
		    (setq pics (cdr pics))
		    (let ((temp-size (nth 8 temp)))
		      (let ((small temp)
			    (small-size temp-size))
			(if (< pic-size small-size)
			    (setq small pic
				  small-size pic-size
				  pic temp
				  pic-size temp-size))
			(while (setq temp (cadr pics))
			  (setq temp-size (nth 8 temp))
			  (cond
			   ((< temp-size small-size)
			    (setq pic small
				  pic-size small-size
				  small temp
				  small-size temp-size))
			   ((< temp-size pic-size)
			    (setq pic temp
				  pic-size temp-size)))
			  (setq pics (cdr pics)))
			(car (if (<= pic-size 120000) pic
			       small)))))
		(car pic)))
	     ((eq type 'large)
	      (while (setq temp (cadr pics))
		(let ((temp-size (nth 8 temp)))
		  (if (> temp-size pic-size)
		      (setq pic temp
			    pic-size temp-size)))
		(setq pics (cdr pics)))
	      (car pic))))))

(defun my/update-emms-from-mpd ()
  "Update EMMS cache from MPD and refresh browser."
  (interactive)
  (require 'emms)
  (message "Updating EMMS cache from MPD...")
  (emms-player-mpd-connect)
  (emms-cache-set-from-mpd-all)
  (message "EMMS cache updated. Refreshing browser...")
  (when (get-buffer "*EMMS Browser*")
    (with-current-buffer "*EMMS Browser*"
      (emms-browser-refresh))))

(defun emms-center-buffer-in-frame ()
  "Add margins to center the EMMS buffer in the frame."
  (let* ((window-width (window-width))
         (desired-width 80)
         (margin (max 0 (/ (- window-width desired-width) 2))))
    (setq-local left-margin-width margin)
    (setq-local right-margin-width margin)
    (setq-local line-spacing 0.2)
    (set-window-buffer (selected-window) (current-buffer))))

(defun my/emms-show-cover ()
  "Display cover art for current track in a buffer."
  (interactive)
  (let ((cover (emms-cover-art-path)))
    (if cover
        (progn
          (switch-to-buffer (get-buffer-create "*emms-cover*"))
          (erase-buffer)
          (insert-image (create-image cover))
          (goto-char (point-min)))
      (message "No cover art found"))))

(defun emms-cover-art-path ()
  "Return cover art path for the current track."
  (when (bound-and-true-p emms-playlist-buffer)
    (let* ((track (emms-playlist-current-selected-track))
           (path (emms-track-get track 'name))
           (dir (file-name-directory path))
           (standard-files '("cover.jpg" "cover.png" "folder.jpg" "folder.png"
                             "album.jpg" "album.png" "front.jpg" "front.png"))
           (standard-cover (cl-find-if
                            (lambda (file)
                              (file-exists-p (expand-file-name file dir)))
                            standard-files)))
      (if standard-cover
          (expand-file-name standard-cover dir)
        (let ((cover-files (directory-files dir nil ".*\\(jpg\\|png\\|jpeg\\)$")))
          (when cover-files
            (expand-file-name (car cover-files) dir)))))))

(defun emms-notify-song-change-with-artwork ()
  "Send song change notification. Uses osascript on macOS, notify-send on Linux."
  (when (bound-and-true-p emms-playlist-buffer)
    (let* ((track  (emms-playlist-current-selected-track))
           (artist (or (emms-track-get track 'info-artist) "Unknown Artist"))
           (title  (or (emms-track-get track 'info-title)  "Unknown Title"))
           (album  (or (emms-track-get track 'info-album)  "Unknown Album"))
           (cover  (emms-cover-art-path)))
      (cond
       ((eq system-type 'darwin)
        (start-process "emms-notify" nil "osascript" "-e"
                       (format "display notification \"%s - %s\" with title \"EMMS\" subtitle \"%s\""
                               artist title album)))
       ((executable-find "notify-send")
        (apply #'start-process
               "emms-notify" nil "notify-send"
               "-a" "EMMS" "-c" "music"
               (append
                (when cover (list "-i" cover))
                (list (format "Now Playing: %s" title)
                      (format "Artist: %s\nAlbum: %s" artist album)))))))))

;; HOOKS

(with-eval-after-load 'emms-browser
  (add-hook 'emms-browser-mode-hook
            (lambda ()
              (face-remap-add-relative 'default '(:background "#2d353b"))
              (emms-center-buffer-in-frame))))

(with-eval-after-load 'emms-playlist-mode
  (add-hook 'emms-playlist-mode-hook
            (lambda ()
              (face-remap-add-relative 'default '(:background "#2d353b"))
              (emms-center-buffer-in-frame))))

(with-eval-after-load 'emms
  (add-hook 'window-size-change-functions
            (lambda (_)
              (when (memq major-mode '(emms-browser-mode emms-playlist-mode))
                (emms-center-buffer-in-frame)))))

;; Keybinds (uncomment and set my-leader-map to use)
;; (with-eval-after-load 'emms
;;   (define-key my-leader-map (kbd "m u") #'my/update-emms-from-mpd)
;;   (define-key my-leader-map (kbd "m d") #'emms-play-directory-tree)
;;   (define-key my-leader-map (kbd "m p") #'emms-playlist-mode-go)
;;   (define-key my-leader-map (kbd "m h") #'emms-shuffle)
;;   (define-key my-leader-map (kbd "m x") #'emms-pause)
;;   (define-key my-leader-map (kbd "m s") #'emms-stop)
;;   (define-key my-leader-map (kbd "m b") #'emms-previous)
;;   (define-key my-leader-map (kbd "m n") #'emms-next)
;;   (define-key my-leader-map (kbd "m o") #'emms-browser))

(provide 'emms-config)
;;; emms-config.el ends here
 

