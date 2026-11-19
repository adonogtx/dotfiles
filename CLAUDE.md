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

## Current work: black system

Decided 2026-11-18 (`docs/desktop.md`, Theme: black system, Gruvbox code). The system goes black; Gruvbox stays only for Ghostty and what runs in it, IntelliJ and Doom; documents stay light. Replaces the Gruvbox system built 2026-11-11. Build in this order, one step per commit, showing the diff and waiting for Gus's OK before each commit; no push until Gus says so:

1. Docs: `desktop.md`, `theme.md`, `pill-spec.md`, `apps.md`, `overview.md`, this file.
2. Quickshell: new values in `config/quickshell/Theme.qml`, same token names (`textOnAccent` stays). List any Gruvbox hex hardcoded elsewhere in `config/quickshell` for Gus, then move it to a token. Back up `~/.config/quickshell/Theme.qml`, copy, test every part of the pill.
3. Borders (`config/hypr/modules/theme.lua`), fuzzel, mako, uosc (`config/mpv/script-opts/uosc.conf`). Check the WhiteSur light icons read on black in fuzzel and tell Gus.
4. Boot and lock (`docs/desktop.md`, Login and Lock), last: `ippo.png` (phrase #f2f2f2) in `config/hypr` and `config/plymouth/ichigo`, `loading.png` (secondary), `hyprlock.conf` and the Plymouth script (background, field fill, edge, placeholder only). Needs `sudo`; back up to `~/backups/plymouth-ichigo-2026-11-18-gruvbox`, `hyprlock.conf.bak-2026-11-18` and `ippo.png.bak-2026-11-18` first; test with `hyprlock -c` (wrong password once) and `plymouth-test.sh`; give the restore commands before the reboot.

Not in this work: the code side (Ghostty, bat, fzf, btop, rmpc, fastfetch, IntelliJ, Doom stay Gruvbox) and the documents side. `config/doom/config.el` has local changes that stay out of every commit of this work.

After each step, set the Theme Status in the docs. Only after a good reboot in step 4 does the Theme Status become done, with the date.
