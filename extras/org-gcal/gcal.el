;;; gcal.el --- Two way sync between Doom and Google Calendar -*- lexical-binding: t; -*-
;;
;; Credentials stay out of the repo, in ~/.config/gus/gcal.env:
;;   GCAL_CLIENT_ID=...
;;   GCAL_CLIENT_SECRET=...
;; Create them at console.cloud.google.com: a project, the Google Calendar API, an OAuth client of type Desktop app.

(defun gus/gcal-env (key)
  (with-temp-buffer
    (insert-file-contents (expand-file-name "~/.config/gus/gcal.env"))
    (when (re-search-forward (concat "^" key "=\\(.*\\)$") nil t)
      (string-trim (match-string 1)))))

(use-package! org-gcal
  :after org
  :config
  (setq org-gcal-client-id (gus/gcal-env "GCAL_CLIENT_ID")
        org-gcal-client-secret (gus/gcal-env "GCAL_CLIENT_SECRET")
        org-gcal-fetch-file-alist '(("adonogtx@gmail.com" . "~/org/calendar.org"))
        org-gcal-remove-api-cancelled-events t)
  ;; New appointments: SPC X a, then SPC m g p to send it to Google Calendar
  (add-to-list 'org-capture-templates
               '("a" "Appointment" entry (file "~/org/calendar.org")
                 "* %?\n:PROPERTIES:\n:calendar-id: adonogtx@gmail.com\n:END:\n:org-gcal:\n%^T\n:END:\n"))
  (map! :map org-mode-map :localleader
        (:prefix ("g" . "gcal")
         "f" #'org-gcal-fetch
         "s" #'org-gcal-sync
         "p" #'org-gcal-post-at-point
         "d" #'org-gcal-delete-at-point)))
