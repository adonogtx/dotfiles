-- Apps launched from binds and autostart. Change them here only.
return {
  terminal = "ghostty",
  browser  = "brave-origin",
  files    = "nautilus --new-window",
  ide      = os.getenv("HOME") .. "/.local/share/JetBrains/Toolbox/scripts/idea",   -- IntelliJ through Toolbox
  launcher = "quickshell ipc call launcher toggle",   -- Launcher (Quickshell)
  menu     = "quickshell ipc call menus toggle",       -- + wifi | bluetooth | sound | control
}
