#!/usr/bin/env bash
# Coder runs this automatically after cloning the dotfiles repo.
# Symlinks configs into $HOME; safe to re-run (idempotent).
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "linked $dst -> $src"
}

# Top-level dotfiles
link "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"
link "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# XDG configs
link "$DOTFILES_DIR/.config/helix/config.toml"   "$HOME/.config/helix/config.toml"
link "$DOTFILES_DIR/.config/zellij/config.kdl"   "$HOME/.config/zellij/config.kdl"
link "$DOTFILES_DIR/.config/nushell/config.nu"   "$HOME/.config/nushell/config.nu"
link "$DOTFILES_DIR/.config/nushell/env.nu"      "$HOME/.config/nushell/env.nu"

# Custom oh-my-zsh theme referenced by ZSH_THEME="luke"
if [ -d "$HOME/.oh-my-zsh" ]; then
  link "$DOTFILES_DIR/.oh-my-zsh-custom/themes/luke.zsh-theme" \
       "$HOME/.oh-my-zsh/custom/themes/luke.zsh-theme"
else
  echo "warning: ~/.oh-my-zsh not found; luke theme not linked" >&2
fi

echo "dotfiles installed."
