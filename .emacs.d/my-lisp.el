;; lisp
(add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/slime")
(require 'slime)
(slime-setup)
(add-to-list 'auto-mode-alist '("\\.cl$" . lisp-mode))
(add-to-list 'auto-mode-alist '("\\.lisp$" . lisp-mode))

;; "c\\(?:\\(?:l\\|omp\\)ojure\\)"
(add-to-list 'load-path "~/.emacs.d/clojure")
(require 'clojure-auto) 

(setq swank-clojure-jar-path "/Users/jedediah/local/jars/clojure.jar")
(setq swank-clojure-extra-classpaths (list "/Users/jedediah/local/jars/clojure-contrib.jar"))

(add-to-list 'load-path "~/.emacs.d/swank-clojure")
(require 'swank-clojure-autoload)

(require 'quack)
(add-to-list 'auto-mode-alist '("\\.scm$" . 'scheme-mode))