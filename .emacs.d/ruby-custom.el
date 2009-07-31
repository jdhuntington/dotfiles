
(autoload 'ruby-mode "ruby-mode" "Load ruby-mode" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))

;; flymake - on the fly syntax check
(load-file "~/.emacs.d/ruby-flymake.el")

;; ri - interactive documentation
(setq ri-ruby-script "/Users/jedediah/.emacs.d/ri-emacs.rb")
(autoload 'ri "ri-ruby.el" nil t)

;; inf - run an inferior process
;;; NOTE - ALL BUFFERS MUST BE TIED TO A FILENAME
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; electric mode
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode)))

;; rails
(add-to-list 'load-path "~/.emacs.d/emacs-rails")
(require 'rails)

