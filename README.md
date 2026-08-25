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
