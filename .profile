export RBENV_ROOT=/usr/local/var/rbenv
export NVM_DIR=$HOME/.nvm
export VOLTA_HOME="$HOME/.volta"
export WORKON_HOME=/usr/local/var/virtualenv
export ASDF_DIR=$HOME/.asdf

export PATH=$(brew --prefix)/opt/python/libexec/bin:$PATH
export PATH=/usr/local/apache2/bin:$PATH
export PATH=/usr/local/share/python:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH

export PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH
export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH
export PATH=$HOME/.npm-global/bin:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$VOLTA_HOME/bin:$PATH

export GOPATH=$HOME/Code/go
export PATH=$PATH:$GOPATH/bin

export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules:$NODE_PATH
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

export HISTIGNORE="&:ls:[bf]g:exit:[ \t]*:$HISTIGNORE"

export FASTLANE_OPT_OUT_USAGE=1

export EDITOR=vim
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
fi

alias e=$EDITOR
alias ..="cd .."

alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
alias df=dotfiles

alias hosts="$EDITOR -a /etc/hosts"

alias astart="sudo apachectl start"
alias astop="sudo apachectl stop"
alias arestart="sudo apachectl restart"

alias showhidden="defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder"

alias serve="python -m SimpleHTTPServer"
alias tunnel="ssh -D 8080 -f -C -q -N"
alias gi="git"
alias gt="git"
alias gti="git"
alias gut="git"
alias got="git"

# http://www.doughellmann.com/docs/virtualenvwrapper/tips.html#tying-to-pip-s-virtualenv-support
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS="--no-site-packages"
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

__hg_ps1() {
  if command -v hg >/dev/null 2>&1; then
    hg branch 2> /dev/null | awk '{printf "(%s)", $1}'
  fi
}

if [[ $SHELL == "/bin/bash" ]]; then
  export PS1='\W/$(__git_ps1 "(%s)")$(__hg_ps1) % '
fi

if [[ -f $(brew --prefix asdf)/asdf.sh ]]; then
  source $(brew --prefix asdf)/asdf.sh
fi

if [[ -f $HOME/.private ]]; then
  source $HOME/.private
fi
