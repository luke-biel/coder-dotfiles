# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Custom two-line prompt (themes/luke.zsh-theme, installed by install.sh)
ZSH_THEME="luke"

plugins=(git rust docker npm)

source $ZSH/oh-my-zsh.sh

# fzf keybindings + completion (omz fzf plugin guesses the wrong distro paths)
for _fzf_dir in /usr/share/fzf /usr/share/doc/fzf/examples; do
  [ -f "$_fzf_dir/key-bindings.zsh" ] && source "$_fzf_dir/key-bindings.zsh"
  [ -f "$_fzf_dir/completion.zsh" ]   && source "$_fzf_dir/completion.zsh"
done
unset _fzf_dir

# --- User configuration ---
export EDITOR=hx

# Aliases
alias helix=hx
alias cat=bat

# direnv
eval "$(direnv hook zsh)"

# Local, non-versioned overrides (PATHs, secrets, machine-specific bits)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
export PATH="$PATH:/home/coder/.local/bin"
