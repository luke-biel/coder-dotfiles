# coder-dotfiles

Personal dotfiles for Fathom Coder workspaces (the `rust` image:
`ghcr.io/fathom-io/coder/rust`).

Coder clones this repo into a workspace and runs `install.sh`, which symlinks
each config into `$HOME`. Add the repo URL under **Account → Dotfiles** in the
Coder dashboard, or run manually:

```sh
coder dotfiles <git-url>
```

> Run `install.sh` as a script (`./install.sh`); don't `source` it. Its
> `set -euo pipefail` leaks into the interactive shell — under zsh, `set -u`
> makes the oh-my-zsh async git prompt stub error on every prompt render.

## What's here

| File                                      | Target                        | Tool (present in rust image)                |
| ----------------------------------------- | ----------------------------- | ------------------------------------------- |
| `.zshrc`                                  | `~/.zshrc`                    | zsh + oh-my-zsh                             |
| `.oh-my-zsh-custom/themes/luke.zsh-theme` | `~/.oh-my-zsh/custom/themes/` | custom two-line prompt (`ZSH_THEME="luke"`) |
| `.gitconfig`                              | `~/.gitconfig`                | git                                         |
| `.config/helix/config.toml`               | `~/.config/helix/config.toml` | helix (`hx`)                                |
| `.config/zellij/config.kdl`               | `~/.config/zellij/config.kdl` | zellij                                      |
| `.config/nushell/config.nu`               | `~/.config/nushell/config.nu` | nushell (`nu`) + oh-my-posh                 |
| `.config/nushell/env.nu`                  | `~/.config/nushell/env.nu`    | nushell                                     |
| `.config/git/hooks/pre-push`              | `~/.config/git/hooks/`        | git (`core.hooksPath`, blocks main/master)  |

## System packages

`install.sh` also apt-installs packages the workspace templates do not ship.
The list lives in [`apt.txt`](apt.txt): one package per line (`#` comments and
blank lines are ignored). `install.sh` checks each against dpkg and installs
the missing ones in a single `apt-get install`. Currently: `apparmor`,
`bubblewrap`, `poppler-utils`, and the Xvfb + X11/GL/font library set that
headless Chromium (Playwright/Puppeteer) needs.

## Global npm tools

`install.sh` runs `npm install -g httpyac` when npm is available and `httpyac`
is not already installed.

## Protected-branch pre-push hook

`.gitconfig` sets `core.hooksPath = ~/.config/git/hooks` globally. The `pre-push`
hook there blocks direct pushes to `main`/`master` for any repo living under a
protected parent dir (default `~/Workspace/fathom-io`).

- Override the dirs per-machine: `export PROTECTED_PARENT_DIRS=/a:/b`
- Bypass a single push: `git push --no-verify`

Note: a global `core.hooksPath` replaces each repo's `.git/hooks`. Only
`pre-push` lives here, so other repos' hooks are simply absent, not broken.
