# Dev

Backend Java study and work tools. Topic blocks: **Decision, Why, Not chosen, Where, Status.**

## Java

**Decision:** sdkman in `~/.local/share/sdkman` for Java (default Temurin), Maven and Gradle.
**Why:** Switch JDK versions per project without touching pacman.
**Not chosen:** mise, pacman JDKs.
**Where:** `install/backend.sh`, `config/zsh/.zshrc`
**Status:** done. Default stays Java 25. Java 21 (`21.0.13.0+9-tem`) installed 2026-11-11 for the DevDojo course, pinned in `~/dev/devdojo/.sdkmanrc`. On JDK 23 and later, Lombok needs `annotationProcessorPaths` in the project's `maven-compiler-plugin` (start.spring.io projects already have it).

## IDE

**Decision:** IntelliJ IDEA (`intellij-idea-oss` from the Arch repos), IntelliJ Light theme, New UI, PlemolJP Console NF 13, native Wayland with `-Dawt.toolkit.name=WLToolkit`. Project SDK: the sdkman JDK.
**Why:** IntelliJ Light keeps one palette for shell and apps (Light Solid). Sharp text at 1.25, no XWayland glitches. Updates come with `pacman -Syu`, covered by snapshots. The package now ships the JetBrains Runtime, which fixed the old font and Markdown issues.
**Not chosen:** VS Code, Doom for Java. Dark theme (until 2026-11-11, with Dark Solid). JetBrains Toolbox (a second package manager, only worth it for a paid Ultimate license).
**Where:** `install/backend.sh`, `config/intellij/`
**Status:** done. IntelliJ Light set by hand in Settings, Appearance (done and tested 2026-11-11). First run checks: Help, About shows `sun.awt.wl.WLToolkit`; a `README.md` preview renders; New Project offers Spring Boot (if not, use start.spring.io). If the Markdown preview fails, reconsider Toolbox.

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
