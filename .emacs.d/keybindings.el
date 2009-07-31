;; JD's keybindings

;; search
(global-set-key "\C-xj" 'global-replace-regexp)
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\C-\M-s" 'isearch-forward)
(global-set-key "\C-\M-r" 'isearch-backward)

;; global generic
(global-set-key "\M-p" 'bury-buffer)
(global-unset-key "\M-x")
(global-set-key "\M-s" 'execute-extended-command)
(global-set-key "\M-x" 'smex)
(global-set-key "\C-x\C-m" 'smex)
(global-set-key "\C-c\C-m" 'smex-major-mode-commands)
(global-unset-key "\C-z") 		; hate the behavior, might as well use the binding
(global-set-key "\C-z" 'kill-word)
(global-set-key (kbd "C-;") 'jlh-insert-hashrocket)
(global-set-key [M-backspace] 'kill-word)
(global-set-key [C-backspace] 'backward-kill-word)
(global-set-key "\C-x\C-a" 'fc-eval-and-replace)
(global-set-key "\C-x\C-o" 'pg-duplicate-this-line)
(global-set-key "\C-x\C-i" 'delete-blank-lines)
(global-set-key "\C-x\C-y" 'jlh-duplicate-region)
(global-set-key (kbd "C-\\") 'dabbrev-expand)
;; (global-set-key (kbd "C-\'") 'jao-copy-line)
(global-set-key (kbd "C-c i") 'insert-date-string)
(global-set-key (kbd "C-c p") 'revert-buffer-force)

(global-set-key (kbd "A-<") 'beginning-of-buffer)
(global-set-key (kbd "A->") 'end-of-buffer)
(global-set-key "\C-x," 'just-one-space)

;; macro related
(defun toggle-kbd-macro-recording-on ()
  "One-key keyboard macros: turn recording on."
  (interactive)
  (start-kbd-macro nil))

(defun toggle-kbd-macro-recording-off ()
  "One-key keyboard macros: turn recording off."
  (interactive)
  (end-kbd-macro))

(global-set-key [f1]       'call-last-kbd-macro)
(global-set-key [\M-f1]    'toggle-kbd-macro-recording-on)
(global-set-key [\S-f1]    'toggle-kbd-macro-recording-off)

(global-unset-key [f3])
(global-set-key [f3] 'ack-in-project)
(global-set-key [f4] 'jlh-copy-whole-buffer)
(global-set-key [f7] 'comment-region)
(global-set-key [f8] 'uncomment-region)

(global-unset-key [home])
(global-unset-key [end])
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)

;; planner related
;; (global-set-key (kbd "C-<f6>") 'planner-goto-today)
;; (global-set-key (kbd "<f6>") 'planner-create-task-from-buffer)


(global-set-key (kbd "C-M-'")  (wrap-region-with-function "'" "'"))
(global-set-key (kbd "C-M-\"") (wrap-region-with-function "\"" "\""))
(global-set-key (kbd "C-M-`")  (wrap-region-with-function "`" "`"))
(global-set-key (kbd "C-M-(")  (wrap-region-with-function "(" ")"))
(global-set-key (kbd "C-M-[")  (wrap-region-with-function "[" "]"))
(global-set-key (kbd "C-M-{")  (wrap-region-with-function "{" "}"))
(global-set-key (kbd "C-M-<")  'wrap-region-with-tag-or-insert)

(add-hook 'erc-mode-hook 'erc-custom-keybindings)
(defun erc-custom-keybindings()
  (define-key erc-mode-map [f5] 'erc-open-last-link))

;; window moving
(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window

;; (define-key javascript-mode-map (kbd "C-c l") 'js-lambda)


;; (defmacro jlh-swap (current-key new-key)
;;   (let ((current-key-sym (gensym))
;; 	(new-key-sym (gensym)))
;;     `(progn
;;        (defun ,current-key-sym () (interactive) (insert ,current-key))
;;        (defun ,new-key-sym () (interactive) (insert ,new-key))
;;        (local-set-key ,current-key ',new-key-sym)
;;        (local-set-key ,new-key ',current-key-sym))))


;; (defun remap-homerow ()
;;   "Switch all numbers with the symbols above them"
;;   (interactive)
;;   (progn
;;     (jlh-swap "1" "!")
;;     (jlh-swap "2" "@")
;;     (jlh-swap "3" "#")
;;     (jlh-swap "4" "$")
;;     (jlh-swap "5" "%")
;;     (jlh-swap "6" "^")
;;     (jlh-swap "7" "&")
;;     (jlh-swap "8" "*")
;;     (jlh-swap "9" "(")
;;     (jlh-swap "0" ")")))

(setq jlh-key-pairs
      '((?! ?1) (?@ ?2) (?# ?3) (?$ ?4) (?% ?5)
        (?^ ?6) (?& ?7) (?* ?8) (?( ?9) (?) ?0)))
        
(defun jlh-key-swap-help (key-pairs)
  (if (eq key-pairs nil)
      (message "Keyboard fubared. S-f10 to fix.")
    (progn
      (keyboard-translate (caar key-pairs)  (cadar key-pairs)) 
      (keyboard-translate (cadar key-pairs) (caar key-pairs))
      (jlh-key-swap-help (cdr key-pairs)))))

(defun jlh-key-restore-help (key-pairs)
  (if (eq key-pairs nil)
      (message "Keyboard normal again. C-S-f10 to fubar.")
    (progn
      (keyboard-translate (caar key-pairs)  (caar key-pairs))
      (keyboard-translate (cadar key-pairs) (cadar key-pairs))
      (jlh-key-restore-help (cdr key-pairs)))))

(defun jlh-key-swap () "Swap number row" (interactive) (jlh-key-swap-help jlh-key-pairs))
(defun jlh-key-restore () "Restore number row" (interactive) (jlh-key-restore-help jlh-key-pairs))

(global-set-key [\S-f10] 'jlh-key-restore)
(global-set-key [\C-\S-f10] 'jlh-key-swap)

(global-set-key [f6]    'bm-next)
(global-set-key [\M-f6]    'bm-toggle)
(global-set-key [\S-f6]    'bm-previous)

;; (global-set-key (kbd "C-c f") 'recentf-ido-find-file)

(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)

(global-set-key (kbd "C-h g") 'magit-status)