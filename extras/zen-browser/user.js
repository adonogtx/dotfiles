// Zen · gus
// Read userChrome.css, and turn off DNS over HTTPS so keiko's /etc/hosts block works.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("network.trr.mode", 5);
