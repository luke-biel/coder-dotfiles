# config.nu
#
# Installed by:
# version = "0.110.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

####
# Config
####

use ~/.dot/fzf.nu

$env.config.show_banner = false
$env.config.buffer_editor = "helix"

oh-my-posh init nu --config jblab_2021

####
# Functions
####

# Find main branch in git repo
def git_main_branch [] {
    # Return early if not in a git repository
    if (do { git rev-parse --git-dir } | complete | get exit_code) != 0 {
        return
    }

    let refs = [
        "refs/heads/main"
        "refs/heads/trunk"
        "refs/remotes/origin/main"
        "refs/remotes/origin/trunk"
        "refs/remotes/upstream/main"
        "refs/remotes/upstream/trunk"
    ]

    for ref in $refs {
        if (do { git show-ref -q --verify $ref } | complete | get exit_code) == 0 {
            # Extract the last path component (equivalent to ${ref:t})
            echo ($ref | path basename)
            return
        }
    }

    echo "master"
}

# Git checkout `main`
def gcm [] {
    git checkout (git_main_branch)
}

# Git switch branch using fzf
def gbs [] {
  let branch = (
    git branch |
    split row "\n" |
    str trim |
    where ($it !~ '\*') |
    where ($it != '') |
    str join (char nl) |
    fzf --no-multi
  )
  if $branch != '' {
    git switch $branch
  }
}

# Git delete branch using fzf
def gbd [] {
  let branches = (
    git branch |
    split row "\n" |
    str trim |
    where ($it !~ '\*') |
    where ($it != '') |
    str join (char nl) |
    fzf --multi |
    split row "\n" |
    where ($it != '')
  )
  if ($branches | length) > 0 {
    $branches | each { |branch| git branch -d $branch }
    ""
  }
}

####
# Aliases
####

alias cat = ^bat
alias gco = git checkout
alias ll = ls -al
alias gst = git status
alias glg = git log --stat
alias hx = helix

### Direnv

use std/config *

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    # If direnv isn't installed, do nothing
    return
  }

  direnv export json | from json | default {} | load-env
  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]
