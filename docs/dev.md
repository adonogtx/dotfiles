# Dev

Backend Java study and work tools. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

## Java

**Decision:** sdkman in `~/.local/share/sdkman` for Java (default Temurin), Maven and Gradle.
**Why:** Switch JDK versions per project without touching pacman.
**Not chosen:** mise, pacman JDKs.
**Where:** `install/backend.sh`, `config/zsh/.zshrc`
**Status:** done. Default stays Java 25. Java 21 (`21.0.13.0+9-tem`) installed 2026-11-11 for the DevDojo course, pinned in `~/dev/devdojo/.sdkmanrc`. On JDK 23 and later, Lombok needs `annotationProcessorPaths` in the project's `maven-compiler-plugin` (start.spring.io projects already have it).

## IDE

**Decision:** IntelliJ IDEA through JetBrains Toolbox (free mode of the unified IDE), Gruvbox Islands Dark Hard (plugin Gruvbox Islands - Theme, lonre, MIT) with its editor scheme, New UI, UI font IBM Plex Sans 13, editor PlemolJP Console NF 13 with line height 1.2, native Wayland with `-Dawt.toolkit.name=WLToolkit`. Launched from `~/.local/share/JetBrains/Toolbox/scripts/idea`. Project SDK: the sdkman JDK. IntelliJ is the code editor; Doom Emacs is the writing editor (`apps.md`, Notes).
**Why:** Lombok did not work with `intellij-idea-oss` (2026-11-11). Spring, debugging and refactoring are what the DevDojo course and the job search need.
**Not chosen:** `intellij-idea-oss` (until 2026-11-11: Lombok). VS Code, Doom for Java. Neovim with jdtls (2026-11-11: weaker Spring and debug support, and a third editor breaks principle 2). IntelliJ Light (until 2026-11-11, with Light Solid). Forking the theme to recolor the frame and checkboxes (2026-11-11: not worth the upkeep yet).
**Where:** Toolbox installed by hand (outside `install/`), `config/intellij/` (`idea64.vmoptions`), `config/hypr/modules/programs.lua`
**Status:** done 2026-11-11: theme and fonts set. The "Start Free Trial" widget cannot be hidden in the unified IDE; accepted. IntelliJ updates through Toolbox, outside `pacman -Syu` and the snapshots. First run checks: Help, About shows `sun.awt.wl.WLToolkit`; a `README.md` preview renders.

## Containers

**Decision:** Docker with compose and buildx, started by socket. Published ports always on 127.0.0.1.
**Why:** Docker writes firewall rules around ufw; `-p 5432:5432` would be open to the whole Wi-Fi.
**Risk:** the docker group equals root; accepted for a single user laptop.
**Where:** `install/backend.sh`
**Status:** done

## PostgreSQL

**Decision:** Both.

| Instance | Use | Detail |
|---|---|---|
| Local (pacman) | everyday queries in DBeaver | peer and scram auth; role created once with `sudo -iu postgres createuser --createdb --pwprompt "$USER"` |
| Docker per project | Spring projects | `postgres:17` pinned, `127.0.0.1:5433:5432` so it never clashes with the local one; database, user and password `app`; healthcheck with `pg_isready`; data in a named volume |

**Why:** Local is quick to explore; Docker pins the version per project.
**Risk:** local major upgrades need `pg_upgrade` (ArchWiki) before rebooting.
**Where:** `install/backend.sh`, `templates/compose.yaml` (copy into a project root; Spring URL `jdbc:postgresql://localhost:5433/app`)
**Status:** done

## API

**Decision:** Bruno for my projects; collections live as `.bru` files inside each project repo. Postman (`postman-bin`, AUR) only for the DevDojo course.
**Why:** Bruno: no account, collections versioned with the code, visible in the portfolio. Postman: the course uses it.
**Not chosen:** Postman for my own projects (account, heavy). httpie (duplicates Bruno). exercism CLI (exercises stay on the website).
**Where:** `install/backend.sh`
**Status:** done. Postman installed 2026-11-11 for the DevDojo course.

## Git

**Decision:** Name Gustavo Thomaz Adono, email the GitHub noreply address, `main` default, rebase on pull, autoSetupRemote, prune on fetch, editor `emacsclient -t`. Global ignore holds only editor and OS files.
**Why:** Gmail stays private; project ignores belong to each project.
**Where:** `config/git/`
**Status:** done

## Folders

**Decision:** Code in `~/dev`, the repo itself in `~/dev/dotfiles`. `.m2` and `.gradle` stay in `$HOME`.
**Status:** done
