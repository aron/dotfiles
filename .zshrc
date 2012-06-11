source ~/.profile

autoload colors && colors
autoload -Uz vcs_info
autoload -Uz compinit && compinit -i
#autoload -U complist

set -o emacs

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
REPORTTIME=10

setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt IGNORE_EOF
setopt AUTO_CD
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

# Prevent zsh conflicting with git commands
alias git="noglob git"

# Source files (the order matters).
source "$HOME/.zsh/terminal.zsh"
source "$HOME/.zsh/completion.zsh"
source "$HOME/.zsh/history.zsh"
source "$HOME/.zsh/directory.zsh"
source /usr/local/etc/bash_completion.d/git-completion.bash

# Load RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

zstyle ':vcs_info:*'  enable git hg svn
zstyle ':vcs_info:*'  check-for-changes true
zstyle ':vcs_info:*'  stagedstr     "+"
zstyle ':vcs_info:*'  unstagedstr   "*"
zstyle ':vcs_info:*'  actionformats "action"
zstyle ':vcs_info:*'  formats       "(%b%c%u%m)"
zstyle ':vcs_info:*'  nvcsformats   ""
zstyle ':vcs_info:git*+set-message:*' hooks git-stash

# Show count of stashed changes
function +vi-git-stash() {
  local -a stashes
  if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+="$"
  fi
}

precmd() {
  vcs_info
}

PROMPT='%~${vcs_info_msg_0_} %% '
RPROMPT=""

# Compile the completion dump, to increase startup speed.
dump_file="$HOME/.zsh/compdump.tmp"
if [[ "$dump_file" -nt "${dump_file}.zwc" || ! -f "${dump_file}.zwc" ]]; then
  zcompile "$dump_file"
fi
unset dump_file
