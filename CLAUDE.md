# CLAUDE.md

Personal Arch Linux + Hyprland system on a ThinkPad T14 Gen 2i. This repo lives at `~/dev/dotfiles`.

## Source of truth

The five docs in `docs/` decide everything: `overview.md`, `base.md`, `desktop.md`, `apps.md`, `dev.md`. Read the relevant one before any change. Every topic uses the block **Decision, Why, Not chosen, Where, Status**.

## Rules

1. Before suggesting a change, check its decision in `docs/`. If it contradicts one, say so and ask before changing it.
2. Frozen by default (principle 3). Push back if Gus starts tweaking for its own sake. Changing a decision means editing its doc block first, with a reason.
3. Prefer the simplest fix that keeps the current structure: `install/` installs packages only, `config/` is copied by hand to `~/.config/`.
4. When a change is accepted, update the doc block it belongs to (Decision, Status) in the same change, and say which section changed.
5. Before a command that touches boot, login or network, check the current state first and give a way back. Gus runs every `sudo` command himself.
6. Never mention zenOS, macOS or Spotlight in docs, comments or files. Japanese appears only where `overview.md` allows it.
   Exception: real package or theme identifiers inside commands and config files.
7. Reply in Portuguese. Write file content, code, comments and commands in English. No emojis, no dashes in replies, tables are welcome. Downloads go to `~/dump`, never `~/Downloads`.

## Working

- Edit files in the repo first, then copy them to `~/.config/` (or `~/.local/bin/`), and say what was copied.
- Back up any file in `~/.config/` before overwriting it (`cp file file.bak`) unless it is identical to the repo.
- Theme colors come only from `config/quickshell/Theme.qml` and `docs/theme.md`; never hardcode a hex that is not a token.
- Commit only when Gus asks. Author is the GitHub noreply address already in the git config.

## Current work

Black system done. Boot and lock done and tested 2026-11-25: photo background, system tokens, filling bar inside the field (commit dda53eb). Matcha is retired. Terminal on panel #0c0c0d with fg2 #d5c4a1 done and tested 2026-11-25 (e9e59c6). IntelliJ Gruvbox Black done and tested 2026-11-25 (63fc8cb).

Next candidates, not started:
- Ctrl + Alt + F2 to F6 shows a frozen frame (to record in `overview.md`, Open questions).
- Settings window reached from the open pill's footer (roadmap; needs its own decision block first).
- Decide org-modern in `apps.md`, Notes.
