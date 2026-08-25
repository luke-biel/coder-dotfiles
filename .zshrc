# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Custom two-line prompt (themes/luke.zsh-theme, installed by install.sh)
ZSH_THEME="luke"

plugins=(git fzf rust cargo docker npm)

source $ZSH/oh-my-zsh.sh

# --- User configuration ---
export EDITOR=helix

# Aliases
alias hx=helix
alias cat=bat

# direnv
eval "$(direnv hook zsh)"

# Local, non-versioned overrides (PATHs, secrets, machine-specific bits)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
