
;; planner mode prefs
(setq planner-use-other-window nil)
(setq planner-carry-tasks-forward t)
;; planner mode
(add-to-list 'load-path "~/.emacs.d/muse/lisp")
(add-to-list 'load-path "~/.emacs.d/planner")
(add-to-list 'load-path "~/.emacs.d/remember")

;; (setq muse-project-alist
;;      '(("WikiPlanner"
;;	 ("~/gtd"   ;; Or wherever you want your planner files to be
;;	  :default "index"
;;	  :major-mode planner-mode
;;	  :visit-link planner-visit-link))
;;	("PersonalWiki" ("~/Documents/wiki" :default "index"))))
;; (require 'planner)
;; (require 'planner-multi)
;; (plan)
