# rmpc

rmpc works with no config: it connects to mpd on 127.0.0.1:6600, which matches `config/mpd/mpd.conf`.

To customize, generate the default config and edit from there, so the file always matches your rmpc version:

```bash
mkdir -p ~/.config/rmpc
rmpc config > ~/.config/rmpc/config.ron
```

Album art works in Ghostty through the Kitty graphics protocol.
