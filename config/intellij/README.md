# IntelliJ IDEA

IntelliJ keeps its settings per version, so this folder holds only what is stable.

`idea64.vmoptions` runs IntelliJ as a native Wayland app: sharp text at 1.25 scaling and none of the XWayland glitches. Copy it into the folder of your installed version:

```bash
cp config/intellij/idea64.vmoptions ~/.config/JetBrains/<IdeaVersion>/idea64.vmoptions
```

Or in IntelliJ: Help › Edit Custom VM Options, and paste the line.

Look used in the deck: Settings › Appearance › Theme: IntelliJ Light, New UI on, editor font PlemolJP Console NF 13.
