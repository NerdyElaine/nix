;;; snippet.el --- Description -*- lexical-binding: t; -*-
(use-package yasnippet
  :straight t
  :ensure t
  :hook ((LaTeX-mode . yas-minor-mode)
         (prog-mode . yas-minor-mode)
         (org-mode  . yas-minor-mode))
  :bind
  (:map yas-keymap
        ("<tab>" . yas-next-field)   
        ("TAB"   . yas-next-field))
  (:map yas-minor-mode-map
        ("<tab>" . nil)              
        ("TAB"   . nil)) 
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :straight t
  :ensure t)

(provide 'snippet)
;;; snippet.el ends here 
