;;; +org.el -*- lexical-binding: t; -*-
;;
;; Org notes system: tasks, appointments, agenda, lists, career, journal.
;; Load it from config.el with:  (load! "+org")
;; Notes live in ~/org

(setq org-directory "~/org/")

(after! org
  ;; Files the agenda reads. Lists, roadmaps and the journal stay out on purpose.
  (setq org-agenda-files
        (list (expand-file-name "todo.org" org-directory)
              (expand-file-name "career.org" org-directory)))

  ;; Task states. career.org defines its own states with a #+TODO: line.
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "KILL(k)")))

  ;; Add CLOSED: [date time] when a task is marked DONE or KILL.
  (setq org-log-done 'time)

  ;; Agenda opens on the current week, Monday to Sunday.
  (setq org-agenda-start-day nil
        org-agenda-span 'week
        org-agenda-start-on-weekday 1)

  ;; Refile (SPC m r r) can move items to any heading in these files.
  (setq org-refile-targets
        '((nil :maxlevel . 2)
          (org-agenda-files :maxlevel . 2)
          ("lists.org" :maxlevel . 1))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil)

  ;; Capture templates (SPC X).
  (setq org-capture-templates
        '(("t" "task" entry
           (file+headline "todo.org" "inbox")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n")

          ("e" "event" entry
           (file+headline "todo.org" "events")
           "* %?\n%^T\n")

          ("d" "daily" plain
           (file (lambda ()
                   (expand-file-name
                    (format-time-string "journal/%Y-%m-%d.org")
                    org-directory)))
           "* backend\n- did: %?\n- where I stopped:\n- next action:\n- pending doubt:\n\n* day\n")

          ("l" "list item")
          ("lw" "watch" item (file+headline "lists.org" "watch") "- [ ] %?")
          ("lr" "read" item (file+headline "lists.org" "read") "- [ ] %?")
          ("lb" "buy" item (file+headline "lists.org" "buy") "- [ ] %?")
          ("li" "project idea" item (file+headline "lists.org" "project_ideas") "- %?")))

  ;; Agenda menu (SPC o A). Custom commands replace the default list,
  ;; so "n" is declared here again.
  (setq org-agenda-custom-commands
        '(("d" "today" agenda "" ((org-agenda-span 'day)))
          ("n" "agenda and todos" ((agenda "") (alltodo ""))))))

;; Optional, later: journal navigation with org-roam.
;; 1. In init.el, change `org' to `(org +roam2)' and run `doom sync'.
;; 2. Uncomment the block below.
;;
;; (setq org-roam-directory "~/org/")
;; (after! org-roam
;;   (setq org-roam-dailies-directory "journal/"
;;         org-roam-dailies-capture-templates
;;         '(("d" "default" entry "* %?"
;;            :target (file+head "%<%Y-%m-%d>.org"
;;                               "#+title: %<%Y-%m-%d>\n")))))
