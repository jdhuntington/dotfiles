;;; project-root.el --- Define a project root and take actions based upon it.

;; Copyright (C) 2008 Philip Jackson

;; Author: Philip Jackson <phil@shellarchive.co.uk>
;; Version: 0.2

;; This file is not currently part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program ; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; project-root.el allows the user to create rules that will identify
;; the root path of a project and then run an action based on the
;; details of the project.

;; Example usage might be to set a default directory in which to run
;; grep or ack. It might be that you want a certain indentation
;; level/type for a particular project.

;; Once project-root-fetch has been run `project-details' will either
;; be nil if nothing was found or the project name and path in a cons
;; pair.

;; An example configuration:

;; (setq project-roots
;;       '(("Generic Perl Project"
;;          :root-contains-files ("t" "lib")
;;          :on-hit (lambda (p)
;;                    (message (car p))))))

;; (add-hook 'cperl-mode-hook 'project-root-fetch)
;; (add-hook 'dired-mode-hook 'project-root-fetch)

;; This defines one project called "Generic Perl Projects" by running
;; the tests path-matches and root-contains-files. Once these tests
;; have been satisfied and a project found then (the optional) :on-hit
;; will be run.

;;; The tests:

;; :path-matches maps to `project-root-path-matches' and
;; :root-contains-files maps to `project-root-upward-find-files'. You
;; can use any amount of tests.

;;; Installation:

;; Put this file into your `load-path' and execute (require
;; 'project-root). The function `project-root-fetch' is the one that
;; does the magic so you could put that in to any hooks you would like
;; to check for projects. E.G:

;; (add-hook 'cperl-mode-hook 'project-root-fetch)

(make-variable-buffer-local
 (defvar project-details nil
  "The name and path of the current project root."))

;; (find-cmd '(prune (name ".svn" ".git" ".CVS" "blib"))
;;           '(type "f"))
(defvar project-root-default-find-command
  (concat "find . \\( \\( -name .svn -or -name "
          ".git -or -name .CVS -or -name blib \\) "
          "-prune -or -true \\) -type f ")
  "The find command used to find files (for
`project-root-find-file'). Should be relative to the project
root.")

(defvar project-root-test-dispatch
  '((:root-contains-files . project-root-upward-find-files)
    (:path-matches . project-root-path-matches))
  "Map a property name to root test function.")

(defvar project-roots nil
  "An alist describing the projects and how to find them.")

(defun project-root-path-matches (re)
  "Apply RE to the current buffer name returning the first
match."
  (let ((filename (cond
                    ;; treat dired specially
                    ((string= major-mode "dired-mode")
                     (dired-get-filename nil t))
                    ;; normal file
                    (buffer-file-name
                     buffer-file-name))))
    (when (and filename (not (null (string-match re filename))))
      (match-string 1 filename))))

(defun project-root-get-root (project)
  "Fetch the root path of the project according to the tests
described in PROJECT."
  (let ((root (plist-get project :root))
        (new-root))
    (catch 'not-a-project
      (mapcar
       (lambda (test)
         (when (plist-get project (car test))
           ;; grab a potentially different root
           (setq new-root
                 (funcall (cdr test) (plist-get project (car test))))
           (cond
             ((null new-root)
              (throw 'not-a-project nil))
             ;; check root is so far consistent
             ((and (not (null root))
                   (not (string= root new-root)))
              (throw 'not-a-project nil))
             (t
              (setq root new-root)))))
       project-root-test-dispatch)
      (when root
        (file-name-as-directory root)))))

;; This really needs refactoring
(defun project-root-fetch (&optional dont-run-on-hit)
  "Attempt to fetch the root project for the current file. Tests
will be used as defined in `project-roots'."
  (interactive)
  (setq project-details
        (catch 'root-found
          (unless (mapc
                   (lambda (project)
                     (let ((name (car project))
                           (run (plist-get (cdr project) :on-hit))
                           (root (project-root-get-root (cdr project))))
                       (when root
                         (when (and root (not dont-run-on-hit) run)
                           (funcall run (cons name root)))
                         (throw 'root-found (cons name root)))))
                   project-roots)
            nil))))

(defun project-root-every (pred seq)
  "Return non-nil if pred of each element, of seq is non-nil."
  (catch 'got-nil
    (mapc (lambda (x)
            (unless (funcall pred x)
              (throw 'got-nil nil)))
          seq)))

(defun project-root-upward-find-files (filenames &optional startdir)
  "Return the first directory upwards from STARTDIR that contains
all elements of FILENAMES. If STATDIR is nil then use
current-directory."
  (let ((default-directory (expand-file-name (or startdir "."))))
    (catch 'pr-finish
      (while t
        (cond
          ((project-root-every 'file-exists-p filenames)
           (throw 'pr-finish default-directory))
          ;; if we hit root
          ((string= (expand-file-name default-directory) "/")
           (throw 'pr-finish nil)))
        ;; try again up a directory
        (setq default-directory
              (expand-file-name ".." default-directory))))))

(defun project-root-shell-command-to-list (find-command)
  "Simply listify the output of a shell command."
  (split-string
   (shell-command-to-string find-command) "\n" t))

(defun project-root-p (&optional p)
  "Check to see if P or `project-details' is valid"
  (let ((p (or p project-details)))
    (and p (file-exists-p (cdr p)))))

(defun project-root-goto-root ()
  "Open up the project root in dired."
  (interactive)
  (if (project-root-p)
      (find-file (cdr project-details))
      (message "No project found.")))

(defun project-root-grep ()
  "Run the grep command from the current project root."
  (interactive)
  (when (project-root-p)
    (let ((default-directory (cdr project-details)))
      (call-interactively 'grep))))

(defun project-root-ack ()
  "Run the ack command from the current project root (if ack is
avalible)."
  (interactive)
  (when (and (fboundp 'ack)
             (project-root-p))
    (let ((default-directory (cdr project-details)))
      (call-interactively 'ack))))

(defun project-root-find-file ()
  "Find a file from a list of those that exist in the current
project."
  (interactive)
  (if (project-root-p)
      (let ((enable-recursive-minibuffers t)
            (default-directory (file-name-as-directory
                                (cdr project-details))))
        (find-file
          (ido-completing-read
           "Find project file:"
           (project-root-shell-command-to-list
            project-root-default-find-command)
          nil t)))
      (message "No project found.")))

(provide 'project-root)
