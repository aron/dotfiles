export PATH=/usr/local/apache2/bin:$PATH
export PATH=/usr/local/share/python:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$HOME/.bin:$PATH
export PATH=/usr/local/n/current/bin:$PATH
export PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
export PATH=$NAVE_PATH:$PATH

export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules:$NODE_PATH
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH

export WORKON_HOME=$HOME/.virtualenvs

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

export HISTIGNORE="&:ls:[bf]g:exit:[ \t]*:$HISTIGNORE"

export EDITOR=mvim

export ACK_OPTIONS="--type-set=less=.less --type-set=coffee=.coffee"

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm  # This loads RVM into a shell session.

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
[ -e "$(which less)" ] && eval "$(rbenv init -)"

pman () {
  man -t $1 | open -a /Applications/Preview.app -f
}

__hg_ps1() {
  hg branch 2> /dev/null | awk "{printf "(%s)", $1}"
}

if [[ $SHELL == "/bin/bash" ]]; then
  export PS1='\W/$(__git_ps1 "(%s)")$(__hg_ps1) % '
  source $HOME/.svn-completion 
  source $HOME/.django-completion
  source /usr/local/etc/bash_completion.d/git-completion.bash
  source /usr/local/etc/bash_completion.d/git-flow-completion.bash
fi
NPM_COMPLETION=/usr/local/etc/bash_completion.d/npm-completion.bash
[ -e NPM_COMPLETION ] && source NPM_COMPLETION

source $HOME/.private
