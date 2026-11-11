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

## Current work: Light Solid

Decided 2026-11-11 (`docs/desktop.md`, Theme: Light Solid). Build in this order, one step at a time, waiting for Gus to test each:

1. `docs/theme.md`: replace the Dark Solid tokens with the Light Solid table.
2. `config/quickshell/Theme.qml` and `config/hypr/modules/theme.lua`.
3. Apps: Ghostty, mako, fuzzel, zathura, rmpc, mpv/uosc, Doom theme (Gus picks a light one).
4. GTK and icons: WhiteSur light, Adwaita light, gsettings in `docs/post-install.md` step 3.
5. Wallpaper `assets/wallpapers/light-solid.png`, then `musashi.png` and `phrase.png` in label ink. The boot screen step needs `sudo` and the checks in `docs/desktop.md`, Login.

After each step, set that item's Status in the docs.
