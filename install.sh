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

# Global git hooks (pre-push guards protected branches; see core.hooksPath)
link "$DOTFILES_DIR/.config/git/hooks/pre-push"  "$HOME/.config/git/hooks/pre-push"

# Custom oh-my-zsh theme referenced by ZSH_THEME="luke"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi
link "$DOTFILES_DIR/.oh-my-zsh-custom/themes/luke.zsh-theme" \
     "$HOME/.oh-my-zsh/custom/themes/luke.zsh-theme"


# System packages (apt). Requires passwordless sudo, which the workspace
# templates provision for the workspace user. Packages are listed in
# apt.txt (one per line; blank lines and '#'-comment lines are ignored).
APT_LIST="$DOTFILES_DIR/apt.txt"

if ! command -v apt-get >/dev/null 2>&1 || ! sudo -n true 2>/dev/null; then
  echo "Skipping apt packages (no apt-get or no passwordless sudo)"
elif [ ! -f "$APT_LIST" ]; then
  echo "Skipping apt packages ($APT_LIST not found)"
else
  # Collect listed packages that are not installed yet.
  missing=()
  while IFS= read -r pkg; do
    if ! dpkg-query -W "$pkg" >/dev/null 2>&1; then
      missing+=("$pkg")
    fi
  done < <(grep -vE '^[[:space:]]*(#|$)' "$APT_LIST")

  if [ "${#missing[@]}" -eq 0 ]; then
    echo "apt packages already installed."
  else
    echo "Installing apt packages: ${missing[*]}"
    if ! sudo -n env DEBIAN_FRONTEND=noninteractive apt-get \
      -o DPkg::Lock::Timeout=300 -o Acquire::Retries=3 update; then
      echo "WARNING: apt-get update failed" >&2
    fi
    if ! sudo -n env DEBIAN_FRONTEND=noninteractive apt-get \
      -o DPkg::Lock::Timeout=300 -o Acquire::Retries=3 \
      install -y --no-install-recommends "${missing[@]}"; then
      echo "WARNING: apt install failed for: ${missing[*]}" >&2
    fi
  fi
fi

echo "dotfiles installed."
