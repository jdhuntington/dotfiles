;; User Story Mode
;; Major mode to author user stories
;; Intended for RSpec's Story Runner
;; JD Huntington
;; 2008.12.10


(require 'font-lock)

(defvar user-story-mode-map nil
  "Keymap for User-Story major mode")

;; Assign default keymap
(setq user-story-mode-map (make-sparse-keymap))


(defconst user-story-keywords
  (eval-when-compile
	(regexp-opt
	 '("Then" "Given" "When") t))
	"Just some words.")

(defconst user-story-warnwords
  (eval-when-compile
	(regexp-opt
	 '("crap!") t))
	"Bad words.")

(defconst user-story-constants
  (eval-when-compile
	(regexp-opt
	 '("Story" "Scenario Outline" "Scenario" ) t))
	"Just some more words.")

(defconst user-story-types
  (eval-when-compile
	(regexp-opt
	 '("And") t))
	"Just 'And'.")

(defun user-story-just-after-beginning-of-line-regexp (regex-words)
  (concat "^\s *\\<\\(" regex-words "\\)\\>"))

(defconst user-story-font-lock-keywords
  (list
   (cons
    "Story:\\(.\\|[\n]\\)*?[\n][\n][\n]"
    'font-lock-comment-face)
   (cons
    (user-story-just-after-beginning-of-line-regexp user-story-keywords)
    'font-lock-keyword-face)
   (cons
    (user-story-just-after-beginning-of-line-regexp user-story-constants)
    'font-lock-variable-name-face)
   (cons
    (user-story-just-after-beginning-of-line-regexp user-story-types)
    'font-lock-type-face)
   (cons
    (concat "\\<\\(" user-story-warnwords "\\)\\>")
    'font-lock-warning-face)
   "Subdued level highlighting for User-story mode."))

(defun user-story-mode-calculate-indent ()
  "calculate indent based off of fontlock keywords"
  (if (looking-at (user-story-just-after-beginning-of-line-regexp user-story-types))
      4
    (if (looking-at (user-story-just-after-beginning-of-line-regexp user-story-keywords))
	4
      (if (looking-at (user-story-just-after-beginning-of-line-regexp user-story-constants))
	  2
	2))))

(defun user-story-mode-indent-current-line ()
  (interactive)
  (let ((indent (save-excursion
		  (progn
		    (beginning-of-line)
		    (user-story-mode-calculate-indent)))))
    (if (not (numberp indent)) 'noindent
        (indent-line-to indent))))

(defvar user-story-mode-syntax-table nil
  "Syntax table for smarty-mode.")

(defun user-story-create-syntax-table ()
  (if user-story-mode-syntax-table
	  ()
	(setq user-story-mode-syntax-table (make-syntax-table))

	; Add comment start & end ({* & *})
	(modify-syntax-entry ?{ "( 1" user-story-mode-syntax-table)
	(modify-syntax-entry ?* ". 23" user-story-mode-syntax-table)
	(modify-syntax-entry ?} ") 4" user-story-mode-syntax-table)
	
	;; Make | a punctuation character
	(modify-syntax-entry ?| "." user-story-mode-syntax-table)
	;; Make " a punctuation character so highlighing works withing html strings
	(modify-syntax-entry ?\" "." user-story-mode-syntax-table)
	)
  (set-syntax-table user-story-mode-syntax-table))

(defun user-story-mode ()
  "Major mode for editing StoryRunner User stories"
  (interactive)
  (kill-all-local-variables)
  (user-story-create-syntax-table)

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
		'((user-story-font-lock-keywords)
		nil ; Keywords only (i.e. no comment or string highlighting
		t   ; case fold
		nil ; syntax-alist
		nil ; syntax-begin
		))
  
  (setq font-lock-maximum-decoration t
		case-fold-search t)
  (use-local-map user-story-mode-map)

  (setq major-mode 'user-story-mode)
  (setq mode-name "User-Story")
  (set (make-local-variable 'indent-line-function) 'user-story-mode-indent-current-line)
  (run-hooks 'user-story-mode-hook))


(provide 'user-story-mode)
;;; user-story-mode.el ends here