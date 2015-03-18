export RBENV_ROOT=/usr/local/var/rbenv
export NVM_DIR=/usr/local/var/nvm
export WORKON_HOME=/usr/local/var/virtualenv

export PATH=/usr/local/apache2/bin:$PATH
export PATH=/usr/local/share/python:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH
export PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH
export PATH=$HOME/.bin:$PATH

export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules:$NODE_PATH
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

export HISTIGNORE="&:ls:[bf]g:exit:[ \t]*:$HISTIGNORE"

export EDITOR=vim

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm  # This loads RVM into a shell session.

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

VIRTUALENV_WRAPPER=/usr/local/share/python/virtualenvwrapper.sh
[ -e $VIRTUALENV_WRAPPER ] && source $VIRTUALENV_WRAPPER

# https://github.com/sstephenson/rbenv
rbenvinit () {
  [ -e "$(which less)" ] && eval "$(rbenv init - zsh)"
}

__hg_ps1() {
  if [ -x "$(which hg)" ]; then
    hg branch 2> /dev/null | awk "{printf \"(%s)\", $1}"
  fi
}

if [[ $SHELL == "/bin/bash" ]]; then
  export PS1='\W/$(__git_ps1 "(%s)")$(__hg_ps1) % '
fi

if [[ -f $HOME/.private ]]; then
  source $HOME/.private
fi

if [[ -f $NVM_DIR/nvm.sh ]]; then
  source $NVM_DIR/nvm.sh
fi
