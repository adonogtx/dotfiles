;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Gustavo Thomaz Adono")

;;; Look: Takuya's type family, doom-one-light to match Light Solid
(setq doom-font (font-spec :family "PlemolJP Console NF" :size 17)
      doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 17)
      doom-serif-font (font-spec :family "IBM Plex Serif" :size 17)
      doom-theme 'doom-one-light
      display-line-numbers-type 'relative)

;;; Org: everything in ~/org, file names in English and lowercase
(setq org-directory "~/org/")

(defvar gus/daily-dir (expand-file-name "daily/" org-directory)
  "One file per day, named YYYY-MM-DD.org.")

(defun gus/daily-path ()
  (expand-file-name (format-time-string "%Y-%m-%d.org") gus/daily-dir))

(defun gus/daily-target ()
  "Capture target: today's daily file, at the end."
  (make-directory gus/daily-dir t)
  (set-buffer (org-capture-target-buffer (gus/daily-path)))
  (goto-char (point-max)))

(after! org
  (setq org-agenda-files (list (expand-file-name "todo.org" org-directory)
                               (expand-file-name "career.org" org-directory))
        org-log-done 'time
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)"))
        org-capture-templates
        '(("t" "todo" entry (file+headline "todo.org" "inbox")
           "* TODO %?\n")
          ("l" "list item" entry (file+headline "lists.org" "refile")
           "* %?\n")
          ("j" "job application" entry (file+headline "career.org" "applications")
           "* %^{company} · %^{role}\n:PROPERTIES:\n:applied: %U\n:link: %^{link}\n:END:\n** description\n%?\n")
          ("d" "daily note" plain (function gus/daily-target)
           "* %<%H:%M> %?\n"))))

(map! :leader
      :desc "today's daily note" "n d" (cmd! (make-directory gus/daily-dir t)
                                            (find-file (gus/daily-path)))
      :desc "help for my org system" "n h" (cmd! (find-file (expand-file-name "help.org" org-directory))))
