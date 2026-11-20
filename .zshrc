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

# OpenCode (installed by the dotfiles startup script)
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"

# >>> Codex installer >>>
export PATH="/home/lukaszbiel/.local/bin:$PATH"
# <<< Codex installer <<<
# shellcheck shell=bash
# fathom-codex-login-reminder (managed, do not edit): prompt users to complete Codex device-code auth.
_codex_login_reminder() {
  if command -v codex >/dev/null 2>&1 && ! codex login status >/dev/null 2>&1; then
    echo
    echo 'Codex is not authenticated for ChatGPT.'
    echo 'Sign in with your company ChatGPT Business account by running:'
    echo '    codex login --device-auth'
    echo 'Never share the one-time device code with anyone.'
    echo
  fi
}
_codex_login_reminder
unset _codex_login_reminder

# Hand off interactive terminals to nushell (zsh stays the login shell).
# Skips `zsh -c`, non-tty sessions, and shells started from inside nu.
if [[ -o interactive && -z $ZSH_EXECUTION_STRING && -t 0 && -t 1 && -z $NU_NESTED ]] && (( $+commands[nu] )); then
  export NU_NESTED=1
  exec nu
fi
