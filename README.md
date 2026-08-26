# coder-dotfiles

Personal dotfiles for Fathom Coder workspaces (the `rust` image:
`ghcr.io/fathom-io/coder/rust`).

Coder clones this repo into a workspace and runs `install.sh`, which symlinks
each config into `$HOME`. Add the repo URL under **Account → Dotfiles** in the
Coder dashboard, or run manually:

```sh
coder dotfiles <git-url>
```

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

## Protected-branch pre-push hook

`.gitconfig` sets `core.hooksPath = ~/.config/git/hooks` globally. The `pre-push`
hook there blocks direct pushes to `main`/`master` for any repo living under a
protected parent dir (default `~/Workspace/fathom-io`).

- Override the dirs per-machine: `export PROTECTED_PARENT_DIRS=/a:/b`
- Bypass a single push: `git push --no-verify`

Note: a global `core.hooksPath` replaces each repo's `.git/hooks`. Only
`pre-push` lives here, so other repos' hooks are simply absent, not broken.
