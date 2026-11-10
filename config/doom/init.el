;;; init.el -*- lexical-binding: t; -*-
;; Small on purpose: agenda, capture, lists and daily notes. Java lives in IntelliJ.

(doom! :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       (vc-gutter +pretty)
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets

       :emacs
       dired
       electric
       undo
       vc

       :checkers
       syntax

       :tools
       (eval +overlay)
       lookup
       magit

       :lang
       emacs-lisp
       markdown
       (org +pretty)
       sh
       yaml
       json

       :config
       (default +bindings +smartparens))
