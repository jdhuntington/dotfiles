(defalias 'scroll-ahead 'scroll-up) 
(defalias 'scroll-behind 'scroll-down) 


(defun set-line-spacing (arg)
  "Set line spacing to a prefix value or to 2"
  (interactive "P")
  (setq-default line-spacing (if arg arg 2)))

(defun custom-add-exec-path (path)
  (progn
    (setenv "PATH" (concat (getenv "PATH") ":" path))
    (setq exec-path (cons path exec-path))))


(defun try-complete-abbrev (old)
  (if (expand-abbrev) t nil))
(setq hippie-expand-try-functions-list
      '(try-complete-abbrev
        try-complete-file-name
        try-expand-dabbrev))

(defun fc-eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))


(defun jlh-copy-whole-buffer ()
  "copy whole buffer to killring, and to OS clipboard"
  (interactive)
    (copy-region-as-kill (point-min) (point-max))
    (message "buffer copied to clipboard"))

(defun jlh-insert-hashrocket ()
  "Insert a ' => '"
  (interactive)
  (insert " => "))

(defun jlh-duplicate-region (n)
  "Duplicate region (as many as prefix argument)"
  (interactive "p")
  (save-excursion
    (copy-region-as-kill (mark) (point))
    (while (< 0 n)
      (yank)
      (setq n (1- n)))))

(defun jao-copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(defun jao-toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (if selective-display nil (or column 1))))

;; (defadvice yank (after indent-region activate)
;;      (indent-region (region-beginning) (region-end) nil))

 (defun pg-duplicate-this-line (n)
   "Duplicates the line point is on. With prefix arg, duplicate current line this many times."
   (interactive "p")
   (save-excursion
     (copy-region-as-kill (line-beginning-position)
                         (progn (forward-line 1) (point)))
      (while (< 0 n)
       (yank)
       (setq n (1- n)))))

;; Insertion of Dates.
(defun insert-date-string ()
  "Insert a nicely formated date string."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(defun totd ()
  (interactive)
  (with-output-to-temp-buffer "*Tip of the day*"
    (let* ((commands (loop for s being the symbols
                           when (commandp s) collect s))
           (command (nth (random (length commands)) commands)))
      (princ
       (concat "Your tip for the day is:n"
               "========================nn"
               (describe-function command)
               "nnInvoke with:nn"
               (with-temp-buffer
                 (where-is command t)
                 (buffer-string)))))))




(defun wrap-region (left right beg end)
  "Wrap the region in arbitrary text, LEFT goes to the left and RIGHT goes to the right."
  (interactive)
  (save-excursion
    (goto-char beg)
    (insert left)
    (goto-char (+ end (length left)))
    (insert right)))

(defmacro wrap-region-with-function (left right)
  "Returns a function which, when called, will interactively `wrap-region-or-insert' using LEFT and RIGHT."
  `(lambda () (interactive)
     (wrap-region-or-insert ,left ,right)))

(defun wrap-region-with-tag-or-insert ()
  (interactive)
  (if (and mark-active transient-mark-mode)
      (call-interactively 'wrap-region-with-tag)
    (insert "<")))

(defun wrap-region-with-tag (tag beg end)
  "Wrap the region in the given HTML/XML tag using `wrap-region'. If any
attributes are specified then they are only included in the opening tag."
  (interactive "*sTag (including attributes): \nr")
  (let* ((elems    (split-string tag " "))
         (tag-name (car elems))
         (right    (concat "</" tag-name ">")))
    (if (= 1 (length elems))
        (wrap-region (concat "<" tag-name ">") right beg end)
      (wrap-region (concat "<" tag ">") right beg end))))

(defun wrap-region-or-insert (left right)
  "Wrap the region with `wrap-region' if an active region is marked, otherwise insert LEFT at point."
  (interactive)
  (if (and mark-active transient-mark-mode)
      (wrap-region left right (region-beginning) (region-end))
    (insert left)))

(defun with-current-line-as-region (lam)
  (save-excursion
    (goto-char (line-beginning-position))
    (set-mark-command)
    (goto-char (line-end-position))
    (lam)))

(defun global-replace-regexp (search replace)
  "Replace a regexp throughout the entire buffer, leave the point and mark untouched"
  (interactive "*sSearch String: \nsReplace Wtih: ")
  (save-excursion
    (replace-regexp search replace nil (point-min) (point-max))))

(defun revert-buffer-force ()
  "Revert the buffer without asking for confirmation"
  (interactive)
  (revert-buffer t t))

(defun current-project-root ()
  "Use project-local-variables to derrive the root of the project"
  (file-name-directory (plv-find-project-file default-directory "")))

(defun jlh-underscore-region ()
  "downcase all characters and replace spaces and dashes with underscores"
  (interactive)
  (save-excursion
    (downcase-region (point) (mark))
    (replace-string " " "_" nil (point) (mark))
    (replace-string "-" "_" nil (point) (mark))))
    
(defun jlh-insert-ruby-test (sut expectation)
  "Insert a \"def test_something_should_somthing\n\nend\" structure"
  (interactive "*sSystem Under Test: \nsExpectation: ")
  (insert
   (concat "def "
	   (downcase
	    (replace-regexp-in-string
	     "[^a-z_]" ""
	     (replace-regexp-in-string " " "_" (concat "test " sut " should " expectation)))) "\n\nend")))

