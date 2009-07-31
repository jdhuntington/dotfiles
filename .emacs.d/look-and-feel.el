(cond ((fboundp 'global-font-lock-mode)
       (global-font-lock-mode t)
       (setq font-lock-maximum-decoration t)))

(tool-bar-mode nil)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-hl-line-mode t)

;; File names in title bars with a twist: Replace HOME with ~ while
;; still working with Emacs' / and HOME's \. And it works for
;; Windows-style HOMEs.
(setq frame-title-format 
      '(:eval 
        (if buffer-file-name
	    (replace-regexp-in-string
	     "\\\\" "/"
	     (replace-regexp-in-string 
	      (regexp-quote (getenv "HOME")) "~"
	      (convert-standard-filename buffer-file-name)))
          (buffer-name))))


;; some fonts that should work
;;; "-apple-inconsolata-medium-r-normal--14-140-72-72-m-140-iso10646-1"
;;; "-apple-monaco-medium-r-normal--13-120-72-72-m-120-iso10646-1"
;;; "-apple-andale mono-medium-r-normal--12-120-72-72-m-120-iso10646-1"

;; TODO - get this font stuff working
;; (setq jd-font-name "monaco")		; typically preferred options - andale mono, monaco, inconsolata
;; (setq jd-font-size 14)
;; (setq jd-font-string (concat "-apple-" jd-font-name "-medium-r-normal--" (number-to-string jd-font-size) "-120-72-72-m-120-iso10646-1"))

 (setq default-frame-alist
       '((cursor-type . bar)
        (font . "-apple-monaco-medium-r-normal--14-140-72-72-m-140-iso10646-1")))

(require 'color-theme)
(color-theme-initialize)
(load-file "~/.emacs.d/themes/color-theme-jp-simple-jd.el")
(load-file "~/.emacs.d/themes/color-theme-blackboard.el")
;; (color-theme-rlx)
;; (color-theme-jedit-grey)
;; (color-theme-jdgreen)
;; (color-theme-dark-blue2)
;; (color-theme-aalto-light)
;; (color-theme-jsc-dark)
;; (color-theme-bhara-jd)
;; (color-theme-deep-blue)
;; (color-theme-blue)
;; (color-theme-zenburn)
 (color-theme-snowish)
;; (color-theme-jp-simple-jd)
;;(color-theme-blackboard)
;; (color-theme-vim-colors)
