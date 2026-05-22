;; emment.el starts here

(use-package ement
  :straight t
  :defer t 
  :commands (ement-mode)
  :config
  ;; Optional: keybindings
  (global-set-key (kbd "C-c t") 'ement-run-at-point)
  (global-set-key (kbd "C-c T") 'ement-run-all-tests))

(provide 'emment)

;; emment.el ends here
