source ~/.profile

fpath=(/usr/local/share/zsh/site-functions $fpath)

autoload colors && colors
autoload -Uz vcs_info
autoload -Uz compinit && compinit -i
#autoload -U complist

set -o emacs
unsetopt nomatch

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
alias wget="noglob wget"
alias curl="noglob curl"

# Source files (the order matters).
source "$HOME/.zsh/terminal.zsh"
source "$HOME/.zsh/completion.zsh"
source "$HOME/.zsh/history.zsh"
source "$HOME/.zsh/directory.zsh"
source "$HOME/.zsh/history-substring-search.zsh"

# Source rbenv completion.
RBENV_COMPLETION=/usr/local/Cellar/rbenv/0.4.0/completions/rbenv.zsh
if [ -f "$RBENV_COMPLETION" ]; then
  source RBENV_COMPLETION
fi

zstyle ':vcs_info:*'  enable git hg svn
zstyle ':vcs_info:*'  check-for-changes true
zstyle ':vcs_info:*'  stagedstr     "+"
zstyle ':vcs_info:*'  unstagedstr   "*"
zstyle ':vcs_info:*'  actionformats "%b|%a"
zstyle ':vcs_info:*'  formats       "(%b%c%u%m) "
zstyle ':vcs_info:*'  nvcsformats   ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stash git-branch

# Add a space between branch and state flag.
function +vi-git-branch() {
  if [[ "${hook_com[staged]}" != "" || "${hook_com[unstaged]}" != "" && "${hook_com[misc]}" != "" || "${hook_com[action]}" != "" ]] ; then
    hook_com[branch]+=" "
  fi
}

# Show indication of stashed changes
function +vi-git-stash() {
  local -a stashes
  if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+="$"
  fi
}

# Show indicator for a dirty directory.
+vi-git-untracked(){
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
    git status --porcelain | grep '??' &> /dev/null ; then
    # This will show the marker if there are any untracked files in repo.
    # If instead you want to show the marker only if there are untracked
    # files in $PWD, use:
    #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
    hook_com[staged]+='%%'
  fi
}

precmd() {
  vcs_info
}

PROMPT='%~ ${vcs_info_msg_0_}%(?.%{$fg_bold[yellow]%}.%{$fg_bold[red]%})%%%{$reset_color%} '
RPROMPT=""

# Compile the completion dump, to increase startup speed.
dump_file="$HOME/.zsh/compdump.tmp"
touch $dump_file
if [[ "$dump_file" -nt "${dump_file}.zwc" || ! -f "${dump_file}.zwc" ]]; then
  zcompile "$dump_file"
fi
unset dump_file
