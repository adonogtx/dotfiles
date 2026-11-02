;;; gus.el --- The look shared with the rest of the system -*- lexical-binding: t; -*-
;;
;; Loaded at the end of config.el. Org itself lives in +org.el.

;; Gruvbox hard, like the terminal and the bar
(setq doom-theme 'doom-gruvbox
      doom-gruvbox-dark-variant "hard"
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15))

;; Japanese text in mincho, the way it appears on the lock screen
(add-hook 'after-setting-font-hook
          (lambda ()
            (dolist (charset '(kana han cjk-misc))
              (set-fontset-font t charset (font-spec :family "Zen Old Mincho")))))

;; Google Calendar sync, only when the org-gcal extra is enabled (dot extra enable org-gcal)
(let ((gcal (expand-file-name "gcal.el" doom-user-dir)))
  (when (file-exists-p gcal) (load gcal)))
