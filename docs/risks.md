# Risks

What can go wrong, how bad it is, and what this repo already does about it. Read once before installing.

## During installation

| Risk | Impact | What the repo does | What you do |
|---|---|---|---|
| Partial upgrade (installing on a stale system) | Broken libraries | `base.sh` refreshes the keyring and runs a full upgrade first | Run `base` before any other module |
| Package conflict (PulseAudio, iptables) with `--noconfirm` | Module stops | `set -e` stops at the first error; modules are safe to rerun | Pick PipeWire in archinstall; resolve the conflict by hand, rerun |
| AUR build fails or asks questions | Module stops | `yay` runs interactively | Stay at the keyboard during `fonts`, `icons`, `backend`, `apps` |
| Malicious or broken AUR package | Code runs as you | AUR kept to 9 packages; yay shows each PKGBUILD | Read the diff before accepting |
| `curl` into bash for sdkman | Code runs as you | Official URL over HTTPS, no rc edits | Accept, or install Java with pacman |
| sdkman fails quietly | No JDK | errexit off only around sdk, Java checked after | Read the warning if it appears |
| User services need a session | `enable_user` fails in a chroot | Units are enabled without `--now` | Run the modules after the first boot, not inside archinstall |
| Snapper setup on an unexpected layout | No snapshots | Manual steps start with a `findmnt` check | Stop if it prints nothing |

## First login

| Risk | Impact | What the repo does | What you do |
|---|---|---|---|
| A Lua dispatcher was renamed in your Hyprland | Some binds missing | Each module loads in protected mode; uncertain dispatchers are isolated; errors show as a notification | Read `hyprctl configerrors`, fix the one line |
| Whole config fails | No desktop | Ctrl + Alt + F2 always gives a text login | Read `~/.local/share/hyprland/hyprland.log` |
| Quickshell QML error | No bar | Desktop still works by keyboard; one file per bar item | Run `quickshell` in a terminal to see the file and line |
| Workspace click uses the new dispatch text | Dots do not switch | Fallback line documented in post-install | Swap one line in `WorkspaceDots.qml` |
| Login manager starts a broken session | Login loop | Plymouth and SDDM installed but not enabled; post-install tests Hyprland and hyprlock from the TTY first; SDDM uses the session file from the hyprland package | Ctrl + Alt + F2, `sudo systemctl disable sddm`, read `journalctl -b -1 -u sddm` |
| Plymouth hook in the wrong place | LUKS asked in text, or no prompt | Post-install shows the full `HOOKS` line | Put `plymouth` before `sd-encrypt`, run `sudo mkinitcpio -P` |
| Emacs daemon without Wayland | Frames fail to open | No systemd unit; `emacsclient -a ''` starts it inside Hyprland | Nothing |

## Over time

| Risk | Impact | What the repo does | What you do |
|---|---|---|---|
| Rolling update breaks something | Anything | snap-pac snapshots every transaction | Boot a snapshot; read archlinux.org news before big updates |
| PostgreSQL major upgrade | Database will not start | Warning in the script and the docs | Follow pg_upgrade, or use Docker pinned to a version |
| Quickshell API change | Pill breaks | Small files, versioned | Read release notes before updating |
| Hyprland plugin ABI | Crash at start | No plugins at all | Keep it that way |

## Security

| Risk | Impact | What the repo does | What you do |
|---|---|---|---|
| Laptop stolen | Everything readable | Docs require LUKS in archinstall | Turn encryption on |
| Lock screen fails to start | Idle and suspend leave the session open | hyprlock (tested upstream), `allow_session_lock_restore`, lock before sleep | Test hyprlock once after install |
| Bug in a custom lock | Unlock without password | No custom lock yet; Quickshell lock postponed | Keep hyprlock until the Quickshell one is tested |
| Wi-Fi or Bluetooth names with shell code | Code runs as you | The pill passes argument lists, no shell | Keep that rule in new QML files |
| Passwords in clipboard history | Stored in plain text | History capped at 50; Super + Shift + C wipes it | Prefer Bitwarden autofill over copy; wipe after copying a password |
| Docker ports bypass ufw | Services open to the LAN | Docs show the 127.0.0.1 binding | Always bind published ports to 127.0.0.1 |
| docker group | Same as root | Script warns before adding you | Accept knowingly, or use rootless Docker |
| PostgreSQL `trust` auth | Any local user is superuser | Cluster created with peer and scram | Create your role with a password |
| mpd on the network | Others control playback | Listens on 127.0.0.1 only | Nothing |
| Incoming connections | Exposed services | ufw denies incoming | Open ports one by one if the homelab needs it |
| SSH server | Remote login | `sshd` installed with openssh but never enabled | Leave it off on the laptop |
| Autologin | Session open at boot | SDDM logs in only after the LUKS password; `autologin.conf` says it must not exist without LUKS | Keep LUKS on; test hyprlock before enabling SDDM |
| Secrets in the public repo | Leaks | Repo holds no keys or tokens; git uses your noreply email | Never copy `~/.ssh` or tokens into it |
