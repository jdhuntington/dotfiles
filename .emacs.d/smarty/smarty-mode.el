;;; smarty-mode.el --- major mode for editing Smarty templates

;; Author:      JD Huntington
;; Maintainer:	JD Huntington
;; Keywords:	languages smarty templates
;; WWW:		http://jdhuntington.com

;; THIS IS A DERIVATIVE WORK
;; Most code is a copy+paste from Benj Carson's Vincent DEBOUT <deboutv@free.fr>'s smarty modes
;; I'm looking for use of snippet.el, font-lock, and little else.

;;; License

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.



;;; Mode map

(defvar smarty-mode-map nil
  "Keymap for Smarty Mode.")

(defun smarty-mode-map-init ()
  "Initialize `smarty-mode-map'."
  (setq smarty-mode-map (make-sparse-keymap))
  ;; template key bindings
  (define-key smarty-mode-map "\C-c\C-t"   smarty-template-map)
  ;; mode specific key bindings
  (define-key smarty-mode-map "\C-c\C-m\C-e"  'smarty-electric-mode)
  (define-key smarty-mode-map "\C-c\C-m\C-s"  'smarty-stutter-mode)
  (define-key smarty-mode-map "\C-c\C-s\C-u"  'smarty-add-source-files-menu)
  (define-key smarty-mode-map "\C-c\M-m"   'smarty-show-messages)
  (define-key smarty-mode-map "\C-c\C-h"   'smarty-doc-mode)
  (define-key smarty-mode-map "\C-c\C-v"   'smarty-version)
  ;; electric key bindings
  (when smarty-intelligent-tab
    (define-key smarty-mode-map "\t" 'smarty-electric-tab))
  (define-key smarty-mode-map " " 'smarty-electric-space)
  (define-key smarty-mode-map "(" 'smarty-electric-open-bracket)
  (define-key smarty-mode-map ")" 'smarty-electric-close-bracket)
  (define-key smarty-mode-map "*" 'smarty-electric-star))

;; initialize mode map for Smarty Mode
(smarty-mode-map-init)

  (use-local-map smarty-mode-map)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Fontification
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar smarty-font-lock-keywords-1
  (list
   
   ;; Fontify built-in functions
   (cons
	(concat (regexp-quote smarty-left-delimiter) "[/]*" smarty-functions-regexp)
	'(1 font-lock-keyword-face))

   (cons
	(concat "\\<\\(" smarty-constants "\\)\\>")
	'font-lock-constant-face)

   (cons (concat "\\(" (regexp-quote (concat smarty-left-delimiter "*")) "\\(\\s-\\|\\w\\|\\s.\\|\\s_\\|\\s(\\|\\s)\\|\\s\\\\)*" (regexp-quote (concat "*" smarty-right-delimiter)) "\\)") 
	 'font-lock-comment-face)

   )
  "Subdued level highlighting for Smarty mode.") 

(defconst smarty-font-lock-keywords-2
  (append
   smarty-font-lock-keywords-1  
   (list

	;; Fontify variable names (\\sw\\|\\s_\\) matches any word character +
	;; underscore
	'("\\$\\(\\(?:\\sw\\|\\s_\\)+\\)" (1 font-lock-variable-name-face)) ; $variable
	'("->\\(\\(?:\\sw\\|\\s_\\)+\\)" (1 font-lock-variable-name-face t t)) ; ->variable
	'("\\.\\(\\(?:\\sw\\|\\s_\\)+\\)" (1 font-lock-variable-name-face t t)) ; .variable
	'("->\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*(" (1 font-lock-function-name-face t t)) ; ->function_call
	'("\\<\\(\\(?:\\sw\\|\\s_\\)+\\s-*\\)(" (1 font-lock-function-name-face)) ; word(
	'("\\<\\(\\(?:\\sw\\|\\s_\\)+\\s-*\\)[[]" (1 font-lock-variable-name-face)) ; word[
	'("\\<[0-9]+" . default)			; number (also matches word)

	;; Fontify strings
	;;'("\"\\([^\"]*\\)\"[^\"]+" (1 font-lock-string-face t t))
	))
  
   "Medium level highlighting for Smarty mode.")

(defconst smarty-font-lock-keywords-3
  (append
   smarty-font-lock-keywords-2
   (list
    ;; Fontify modifiers
    (cons (concat "|\\(" smarty-modifiers-regexp "\\)[:|]+") '(1 font-lock-function-name-face))
    (cons (concat "|\\(" smarty-modifiers-regexp "\\)" (regexp-quote smarty-right-delimiter)) '(1 font-lock-function-name-face))
    
    ;; Fontify config vars
    (cons (concat (regexp-quote smarty-left-delimiter) "\\(#\\(?:\\sw\\|\\s_\\)+#\\)") '(1 font-lock-constant-face))))
  "Balls-out highlighting for Smarty mode.")

(defconst smarty-font-lock-keywords-4
  (append
   smarty-font-lock-keywords-3
   (list
    ;; Fontify plugin functions
    (cons
     (concat (regexp-quote smarty-left-delimiter) "[/]*" smarty-plugins-functions-regexp)
     '(1 font-lock-keyword-face))

    (cons (concat "|\\(" smarty-plugins-modifiers-regexp "\\)[:|]+") '(1 font-lock-function-name-face))
    (cons (concat "|\\(" smarty-plugins-modifiers-regexp "\\)" (regexp-quote smarty-right-delimiter)) '(1 font-lock-function-name-face)))))

(defvar smarty-font-lock-keywords smarty-font-lock-keywords-3
  "Default highlighting level for Smarty mode")