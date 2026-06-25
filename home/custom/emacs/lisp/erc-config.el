;;; erc-config.el --- IRC configuration for emacs -*-lexical-binding: t; -*-

(use-package erc
  :ensure nil
  :custom
  (erc-nick "nerdyelaine")
  (erc-user-full-name "Elaine")
  (erc-server "irc.libera.chat")
  (erc-port 6697)

  (erc-log-channels-directory "~/.emacs.d/erc-logs/")
  (erc-save-buffer-on-part t)    
  (erc-log-write-after-send t)   
  (erc-log-write-after-insert t) 

  (erc-autojoin-channels-alist
   '(("libera.chat" "#emacs" "#nixos" "#nixdarwin")))

  (erc-modules
   '(autojoin
     button
     completion
     fill
     irccontrols
     list
     log
     match
     move-to-prompt
     netsplit
     networks
     noncommands
     notifications
     readonly
     ring
     stamp
     track))
  
  ;; SASL
  (erc-sasl-mechanism 'plain)
  (erc-sasl-user "nerdyelaine")
  
  (erc-use-auth-source-for-nickserv-password t)

  ;; Cosmetic
  (erc-fill-column 120)
  (erc-timestamp-format "[%H:%M] ")
  (erc-hide-list '("JOIN" "PART" "QUIT"))  ; reduce noise

  :config
  (require 'erc-sasl)
  (add-to-list 'erc-modules 'sasl)
  (setq auth-sources '("~/.authinfo.gpg"))
  (erc-update-modules))

(provide 'erc-config)

;;; erc-config.el ends here
