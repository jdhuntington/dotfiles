(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'alt)

(setq default-indicate-empty-lines t)
(setq indicate-empty-lines t)



(require 'override-keymaps)

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

(setq transient-mark-mode nil)

(setq visible-bell t)
(winner-mode 1)

(column-number-mode 1)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

(display-time)

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default ispell-program-name "/opt/local/bin/aspell")
(setq ispell-process-directory (expand-file-name "~/"))

(require 'bm)

(require 'psvn)

(setq show-trailing-whitespace t)

(defun jd-toggle-fullscreen ()
  "Found on http://amitp.blogspot.com/2008/05/emacs-full-screen-on-mac-os-x.html"
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
