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

## Current work: Gruvbox

Decided 2026-11-11 (`docs/desktop.md`, Theme: Gruvbox; dark for the system, light for documents). Build in this order, one step per commit, waiting for Gus to test each:

1. `config/hypr/ippo.png` and `config/plymouth/ichigo/ippo.png` (一歩一歩, vertical, Yuji Boku, phrase color).
2. `config/quickshell/Theme.qml` and `config/hypr/modules/theme.lua`.
3. Terminal: `config/ghostty/themes/gruvbox`, bat `ansi`, `FZF_DEFAULT_OPTS`, `config/btop/themes/gruvbox.theme`.
4. fuzzel, mako, rmpc (`themes/gruvbox.ron`), uosc, Doom (`doom-gruvbox`, `(org +pretty)`). Light Solid files stay in git. zathura, GTK and Brave Origin stay light.
5. `BatteryItem.qml`: live item and the 20% and 10% notifications (`docs/pill-spec.md`, Rest).
6. Boot screen (`docs/desktop.md`, Login): needs `sudo`, the current state shown first and a backup to `~/backups/plymouth-ichigo-2026-11-11-crest`; test with `plymouth-test.sh` before any `limine-mkinitcpio`.
7. Lock (`docs/desktop.md`, Lock): `hyprlock.conf`, tested from a terminal with a wrong password once before replacing the old file.

Not in this work: the IntelliJ theme (Gus sets it by hand, `docs/dev.md`, IDE) and the volume indicator (open question in `docs/overview.md`). The wallpaper picker (`gus-wallpaper`, Super + W) was added 2026-11-11. When the rest is built, the Theme status becomes "done except the IntelliJ theme (manual, dev.md, IDE)", with the date.

After each step, set that item's Status in the docs.
