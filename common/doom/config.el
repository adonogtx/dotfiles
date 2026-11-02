;;; config.el -*- lexical-binding: t; -*-
;;
;; Personal settings. Reload with SPC h r r.

(setq user-full-name "Gustavo Thomaz Adono"
      user-mail-address "adonogtx@gmail.com")

;; Look
(setq doom-theme 'doom-gruvbox)

;; Change the family if this font is not installed
;; (check with: fc-list | grep -i jetbrains)
(setq doom-font (font-spec :family "JetBrains Mono" :size 14))

;; Relative line numbers: 6k / 6j jump to the numbers on the left
(setq display-line-numbers-type 'relative)

;; Org notes system (tasks, agenda, capture, lists, career, journal)
(load! "+org")

;; Gruvbox hard, fonts and Japanese in mincho, shared with the rest of the system
(load! "gus")
