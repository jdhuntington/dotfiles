;;;;;;;;; Load path and files ;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d")

(load-file "~/.emacs.d/jd-auto-modes-and-hooks.el")
(load-file "~/.emacs.d/jd-utilities.el")
(load-file "~/.emacs.d/jd-interface-tweaks.el")
(load-file "~/.emacs.d/jd-webdev-addons.el")
(load-file "~/.emacs.d/jd-erc.el")
(load-file "~/.emacs.d/jd-projects.el")
(load-file "~/.emacs.d/custom-functions.el")
(load-file "~/.emacs.d/keybindings.el")
(load-file "~/.emacs.d/look-and-feel.el")
(load-file "~/.emacs.d/org-remember-planner.el")

;; MOST IMPORTANT LAST
(custom-add-exec-path "/opt/local/bin")
(custom-add-exec-path "/usr/local/bin")
(custom-add-exec-path "/Users/jedediah/bin")
(custom-add-exec-path "/Users/jedediah/local/bin")
(custom-add-exec-path "/Users/jedediah/src/plt/bin")

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))

(setq abbrev-file-name "~/.emacs.d/abbrev_defs")
(setq eshell-aliases-file "~/.emacs.d/eshell-aliases")
(setq save-abbrevs t)
(quietly-read-abbrev-file)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(erc-prompt-face ((t (:background "Black" :foreground "White" :strike-through nil :weight bold)))))

(server-start)

(require 'smex)
(smex-initialize)

;;; emacs automatically puts this stuff here
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(load-file "~/.emacs.d/custom.el")