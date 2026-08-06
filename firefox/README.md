# firefox

steps to apply and remove the firefox and sidebery files stored in this directory.

## install

1. install sidebery.

2. export your current sidebery settings as a backup.

3. open `about:config` and set this preference to `true`:

       toolkit.legacyUserProfileCustomizations.stylesheets

4. open `about:support` and find the active profile directory.

5. close firefox.

6. set the exact profile path:

       profile="/path/from/about:support"

7. create the chrome directory:

       mkdir -p "$profile/chrome"

8. link `userChrome.css`:

       ln -sfn \
         "$HOME/dev/dotfiles/firefox/userChrome.css" \
         "$profile/chrome/userChrome.css"

9. import this file through sidebery settings:

       ~/dev/dotfiles/firefox/sidebery.json

10. apply `sidebery_styles.css` through the sidebery styles editor only when the imported json has not already applied it.

11. reopen firefox.

## remove

1. close firefox.

2. set the same profile path:

       profile="/path/from/about:support"

3. remove the `userChrome.css` link:

       rm -f "$profile/chrome/userChrome.css"

4. open `about:config` and set this preference to `false`:

       toolkit.legacyUserProfileCustomizations.stylesheets

5. restore your previous sidebery backup or reset its settings.

6. remove the custom sidebery css.

7. reopen firefox.
