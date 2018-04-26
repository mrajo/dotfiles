# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

### ac

. ~/.bash/git-prompt.sh
#export PROMPT_COMMAND='__git_ps1 "\n\[\e[0m\][\[\e[0;32m\]\u@\H\[\e[0m]\]\[\e[1;32m\]" "\n\[\e[0m\]\$ ";'$PROMPT_COMMAND
export PROMPT_COMMAND='__git_ps1 "\n\[$(tput setaf 7)\][\[$(tput setaf 2)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 2)\]\h \[$(tput setaf 6)\]\w\[$(tput setaf 7)\]]\[$(tput sgr0)\]" "\n\[\e[0m\]\$ ";'$PROMPT_COMMAND

# paths
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# ruby
if [[ -f "/usr/local/share/chruby/chruby.sh" ]]; then
    . /usr/local/share/chruby/chruby.sh
    . /usr/local/share/chruby/auto.sh
    chruby ruby-2.5.1
fi

# node
export NVM_DIR="/home/acastle/.nvm"
if [[ -f "$NVM_DIR/nvm.sh" ]] ; then
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
    nvm use node > /dev/null
    export PATH="./node_modules/.bin:$PATH"
fi

# rust
if [[ -d "$HOME/.cargo" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# git auto complete
[[ -f ~/.bash/git-completion.sh ]] && . ~/.bash/git-completion.sh

# go
[[ -s "/home/acastle/.gvm/scripts/gvm" ]] && . "/home/acastle/.gvm/scripts/gvm"

# bash aliases
[[ -f ~/.bash/.bash_functions ]] && . ~/.bash/.bash_functions
[[ -f ~/.bash/.bash_aliases ]] && . ~/.bash/.bash_aliases

# WSL starts in user profile dir, not home dir
cd