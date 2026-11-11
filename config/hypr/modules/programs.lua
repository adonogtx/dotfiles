-- Apps launched from binds and autostart. Change them here only.
return {
  terminal = "ghostty",
  browser  = "brave-origin",
  files    = "nautilus --new-window",
  editor   = "emacsclient -c -a ''",     -- starts the daemon on first use, inside Hyprland
  ide      = "intellij-idea-oss",
  launcher = "quickshell ipc call launcher toggle",   -- Launcher in the bar
  menu     = "quickshell ipc call menus toggle",       -- + wifi | bluetooth | sound | control
}
