(defmacro jd-erc-make-cmd(action response)
  "makes an erc command"
  `(defun ,(intern (concat "erc-cmd-" (upcase action))) nil "does some action" (erc-send-action (erc-default-target) ,response)))

(jd-erc-make-cmd "laugh" "laughs")
(jd-erc-make-cmd "lol" "laughs out loud")
(jd-erc-make-cmd "chuckle" "chuckles")
(jd-erc-make-cmd "guffaw" "guffaws")
(jd-erc-make-cmd "rotfl" "rolls on the floor laughing")


(defun erc-cmd-FISH (name)
  "slap someoone with a fish"
  (erc-send-action (erc-default-target) (format "slaps %s with a cold fish." name)))

(defun erc-cmd-ITUNES ()
  "Show currently playing in iTunes"
  (erc-send-action (erc-default-target) (concat "is " (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string  "/usr/local/bin/ruby /Users/jedediah/.emacs.d/ShowItunesTrack.rb")))))

(defun erc-cmd-SS ()
  "THAT's WHAT SHE SAID!!!"
  (erc-send-message "THAT's WHAT SHE SAID!!!"))

;; Todo:
;; 'words' should be defined by the user so that they are able to have access to the naming of the variable
(defmacro defslashcmd (cmd body)
 `(defun ,(intern (concat "erc-cmd-" (upcase cmd))) (&rest words) "Sorry, no documentation yet"
   (if words (erc-send-message ,body)
     (erc-display-message nil 'notice 'active "No text to process"))))

;; Todo:
;; x shouldn't be used here
;; However, I'm tired and I want to go to bed
(defmacro jd-erc-process-by-char (modifier)
 `(substring (mapconcat (function (lambda (x) ,modifier )) (split-string (mapconcat 'identity words " ") "") "") 1))

(defslashcmd "dop"     (mapconcat (function (lambda (x) (format "%s %s" x x))) words " "))
(defslashcmd "rev"     (apply 'concat (reverse (split-string (mapconcat 'identity words " ") ""))))
(defslashcmd "sarcasm" (format "<sarcasm>%s</sarcasm>"  (mapconcat 'identity words " ")))
(defslashcmd "big"     (jd-erc-process-by-char (format " %s" (capitalize x))))
(defslashcmd "card"    (jd-erc-process-by-char (format "|%s" x)))

(fset 'erc-open-last-link
   [?\C-r ?h ?t ?t ?p ?\C-f return ?\M->])


;; URL catcher for ERC, written by Oliver Scholz.  Places URLs into an
;; *ERC URLS* buffer as they're sent to IRC channels.
(defvar my-erc-url-buffer "*ERC URLS*")

(defun my-scan-erc-urls ()
  (require 'erc-button)
  (save-excursion
    (let ((urls nil)
          (chann (or (erc-default-target)
                     "SERVER")))
      (goto-char (point-min))
      (while (re-search-forward erc-button-url-regexp nil t)
        (push (buffer-substring-no-properties
               (match-beginning 0)
               (match-end 0))
              urls))
      (when urls
        (with-current-buffer (get-buffer-create my-erc-url-buffer)
          (goto-char (point-max))
          (unless (eq (char-before) ?\n)
            (newline))
          (insert (mapconcat (lambda (str)
                               (format "(%s) %s: %s" (format-time-string "%Y.%m.%d %H:%M") chann str))
                             urls "\n")))))))

(add-hook 'erc-insert-modify-hook 'my-scan-erc-urls) 