;;; init.el -*- lexical-binding: t; -*-
;;
;; Doom modules. After changing this file, run `doom sync' in a terminal
;; and restart Emacs.

(doom! :input

       :completion
       (corfu +orderless)  ; completion popup
       vertico             ; search and pick: SPC f f, SPC :, SPC s i

       :ui
       doom                ; doom look
       doom-dashboard      ; start screen
       hl-todo             ; highlight TODO/FIXME in code
       modeline            ; bottom bar
       ophints             ; highlight what an operator acted on
       (popup +defaults)   ; agenda, help and capture in popups
       (vc-gutter +pretty) ; git changes in the margin
       vi-tilde-fringe     ; ~ after the end of a file
       workspaces          ; tab-like workspaces

       :editor
       (evil +everywhere)  ; vim keys
       file-templates
       fold                ; zc / zo folding
       snippets

       :emacs
       dired               ; file manager
       electric
       undo
       vc

       :term
       vterm

       :checkers
       syntax

       :tools
       (eval +overlay)
       lookup
       magit               ; git: SPC g g

       :lang
       emacs-lisp
       json
       markdown
       org                 ; later, for journal navigation: (org +roam2)
       sh
       yaml

       :config
       (default +bindings +smartparens))
