(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(add-to-list 'load-path "~/.emacs.d/remember")
(require 'remember)

(setq org-remember-templates
     '((?t "* TODO %?\n  %i\n  %a" "~/gtd.org")
       (?a "* Appointment: %?\n%^T\n%i\n  %a" "~/gtd.org")))

(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(eval-after-load 'remember
 '(add-hook 'remember-mode-hook 'org-remember-apply-template))

(global-set-key (kbd "C-c r") 'remember)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-todo-keywords '("TODO" "STARTED" "WAITING" "DONE"))
(setq org-agenda-include-diary t)
(setq org-agenda-include-all-todo t)
