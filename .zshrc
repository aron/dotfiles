fpath=(~/.homebrew/bin/share/zsh/site-functions $fpath)

autoload colors && colors
# autoload -Uz vcs_info
autoload -Uz compinit && compinit -i
autoload -U complist

source ~/.profile

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
alias wget="noglob wget"
alias curl="noglob curl"

# Source files (the order matters).
source "$HOME/.zsh/terminal.zsh"
source "$HOME/.zsh/completion.zsh"
source "$HOME/.zsh/history.zsh"
source "$HOME/.zsh/directory.zsh"
source "$HOME/.zsh/history-substring-search.zsh"

zstyle ':vcs_info:*'  enable git hg svn
zstyle ':vcs_info:*'  check-for-changes true
zstyle ':vcs_info:*'  stagedstr     "+"
zstyle ':vcs_info:*'  unstagedstr   "*"
zstyle ':vcs_info:*'  actionformats "%b|%a"
zstyle ':vcs_info:*'  formats       "(%b%c%u%m) "
zstyle ':vcs_info:*'  nvcsformats   ""
# zstyle ':vcs_info:git*+set-message:*' should-check-for-changes hooks git-untracked git-stash git-branch

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

function should-check-for-changes() {
  local d
  local -a cfc_dirs
  blacklist_dirs=(
    ${HOME}/src/xplat/*(/)
  )

  for d in ${blacklist_dirs}; do
    d=${d%/##}
    [[ $PWD == $d(|/*) ]] && return 1
  done
  return 0
}

precmd() {
  # vcs_info
}

gitbranch() {
  branch="$(git rev-parse --abbrev-ref HEAD 2&> /dev/null)"
  if [[ "$branch" != "" ]]; then
    echo "($branch) "
  fi
  echo ""
}

# PROMPT='%~ ${vcs_info_msg_0_}%(?.%{$fg_bold[yellow]%}.%{$fg_bold[red]%})%%%{$reset_color%} '
PROMPT='%~ $(gitbranch)%(?.%{$fg_bold[yellow]%}.%{$fg_bold[red]%})%%%{$reset_color%} '
RPROMPT=""

if [ "$SSH_CONNECTION" != "" ]; then
  PROMPT='%{$fg[yellow]%}%m%{$reset_color%}'$PROMPT
fi

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
