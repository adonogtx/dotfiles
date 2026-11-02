# First boot checklist

Things only the real machine can confirm. If one fails, `hyprctl configerrors`,
`journalctl --user -b` and `qs log` usually say why.

- [ ] Hyprland starts on tty1 and `hyprctl configerrors` is empty
- [ ] Gaps, blue border on the focused window, no transparency
- [ ] Caps Lock works as Ctrl; accents and the layout match the console
- [ ] The bar: kamon, workspaces, 11月2日(月), icons; each panel opens
- [ ] Clicking a workspace number in the bar switches to it
- [ ] Volume and brightness keys work, also on the lock screen
- [ ] SUPER + CTRL + L: the ensō lock screen, time centered in the circle, phrase at the bottom
- [ ] After 5 minutes idle the screen locks; after 6 it turns off
- [ ] Notifications: blue border; `notify-send -a keiko test` shows yellow
- [ ] `keiko start 1 test`: youtube.com does not load; 稽古 1m shows in the bar; it ends by itself
- [ ] The first terminal of the day opens the opening ritual
- [ ] SUPER + SHIFT + S: region screenshot lands in ~/media/pictures/screenshots and the clipboard
- [ ] A USB drive mounts by itself; in yazi, g then m goes to it; M ejects
- [ ] Japanese input: Ctrl + Space switches fcitx5 to mozc in Zen and Doom
- [ ] Doom opens in Gruvbox and SPC n j j opens today's journal
