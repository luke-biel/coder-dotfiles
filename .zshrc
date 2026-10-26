# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Custom two-line prompt (themes/luke.zsh-theme, installed by install.sh)
ZSH_THEME="luke"

# oh-my-zsh master ships async git prompt stubs that read
# _OMZ_ASYNC_OUTPUT[...]. The background handler is only registered (and the
# key populated) when $(git_prompt_status) appears literally in $PS1; the luke
# theme calls it via mygit(), so the key stays unset — and under `set -u`
# (e.g. after sourcing install.sh) the stub errors on every prompt render.
# Use the sync wrappers instead.
zstyle ':omz:alpha:lib:git' async-prompt no

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
export PATH="$PATH:/home/lukaszbiel/.local/bin"

# opencode (user-installed; not part of the rust template)
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"

# >>> Codex installer >>>
export PATH="/home/lukaszbiel/.local/bin:$PATH"
# <<< Codex installer <<<
