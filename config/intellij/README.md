# IntelliJ IDEA

IntelliJ comes from JetBrains Toolbox (installed by hand) and keeps its settings per version, so this folder holds only what is stable.

`idea64.vmoptions` runs IntelliJ as a native Wayland app: sharp text at 1.25 scaling and none of the XWayland glitches. Toolbox writes its own lines into the file of the installed version, so append ours instead of replacing it:

```bash
cat config/intellij/idea64.vmoptions >> ~/.config/JetBrains/<IdeaVersion>/idea64.vmoptions
```

Or in IntelliJ: Help › Edit Custom VM Options, and paste the line.

Theme: `gruvbox-black/` is Gruvbox Black, Gruvbox Islands Dark Hard by Lonre Wang and Vincent Parizet (MIT, `META-INF/LICENSE`) with only the background shades changed. Build the plugin and install it with Settings › Plugins › ⚙ › Install Plugin from Disk (IntelliJ 2025.3 or later):

```bash
cd config/intellij/gruvbox-black && zip -r ~/dump/gruvbox-black-1.0.0.jar META-INF gruvbox_black.theme.json gruvbox_black.xml
```

Look: Settings › Appearance › Theme: Gruvbox Black, its editor scheme (Gruvbox Black), New UI on, UI font IBM Plex Sans 13, editor font PlemolJP Console NF 13, line height 1.2.
