;; JD Huntington
;; auto modes and hooks
;; 2008-03-18
;; Enjoy.

;; Note - What should this file actually be named?


;; some modes are complicated enough they deserve their own file
;; ruby is one of these modes
(load-file "~/.emacs.d/my-ruby.el")
(load-file "~/.emacs.d/my-rails.el")
(load-file "~/.emacs.d/my-lisp.el")
(load-file "~/.emacs.d/starter-kit-eshell.el")
(require 'starter-kit-eshell)

;; css
(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))

;; haskell
(add-to-list 'load-path "~/.emacs.d/haskell")
(require 'inf-haskell)
(autoload 'haskell-mode "haskell-mode" "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode" "Major mode for editing literate Haskell scripts." t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-to-list 'auto-mode-alist '("\\.[hg]s$"  . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.hi$"     . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.l[hg]s$" . literate-haskell-mode))

;; php
(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(require 'php-electric)
(add-hook 'php-mode-hook '(lambda () (php-electric-mode)))
(add-hook 'php-mode-hook '(lambda () (message "go **** yourself")))

;; javascript
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; [x|xht|ht]ml
;; (add-to-list 'load-path "~/.emacs.d/nxml")
;; (add-to-list 'load-path "~/.emacs.d/nxhtml")
;; (load "~/.emacs.d/nxml/rng-auto.el")
;; (load "~/.emacs.d/nxhtml/autostart.el")

;; scpaste
;; TODO - this does not belong
(autoload 'scpaste "scpaste" "Paste the current buffer." t nil)
(setq scpaste-http-destination "http://jdhuntington.com/paste")
(setq scpaste-scp-destination  "bubbleyum.dreamhost.com:~/jdhuntington.com/current/public/paste")

;; Git
(add-to-list 'load-path "~/.emacs.d/magit")
(load "~/.emacs.d/magit/magit.el")
(require 'magit)

;; Erlang
(add-to-list 'load-path "/usr/local/lib/erlang/lib/tools-2.6.1/emacs")
(setq erlang-root-dir "/usr/local/lib/erlang") 
(setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(require 'erlang-start) 
(add-to-list 'load-path "~/.emacs.d/distel/elisp")
(require 'distel)
(distel-setup)

;; User Stories
(require 'user-story-mode)
(add-to-list 'auto-mode-alist '("\\.feature$" . user-story-mode))