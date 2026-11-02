;;; gus.el --- Gruvbox, fonts and the journal for the day rituals -*- lexical-binding: t; -*-
;;
;; Loaded from config.el with:  (load! "gus")
;; Needs these modules in init.el:  :ui doom  :lang (org +journal)

;; Look: the same Gruvbox and fonts as the rest of the system
(setq doom-theme 'doom-gruvbox
      doom-gruvbox-dark-variant "hard"
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-serif-font (font-spec :family "Zen Old Mincho" :size 15)
      display-line-numbers-type 'relative)

;; Japanese text in mincho, the way it appears on the lock screen
(add-hook 'after-setting-font-hook
          (lambda ()
            (set-fontset-font t 'japanese-jisx0208 (font-spec :family "Zen Old Mincho"))
            (set-fontset-font t 'kana (font-spec :family "Zen Old Mincho"))))

;; Notes and the journal written by `day close`
(setq org-directory "~/docs/notes/")

(after! org-journal
  (setq org-journal-dir "~/docs/notes/journal/"
        org-journal-file-format "%Y%m%d.org"
        org-journal-file-type 'daily
        org-journal-date-format "%A, %Y-%m-%d"))

(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
        ;; DONE gets a CLOSED date, which is how `day close` finds what was done today
        org-log-done 'time
        org-agenda-files (list org-directory)))

;; Google Calendar sync lives in extras/org-gcal; enable it with: dot extra org-gcal
(let ((gcal (expand-file-name "gcal.el" doom-user-dir)))
  (when (file-exists-p gcal) (load gcal)))
