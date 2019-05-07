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

. "$HOME/.bash/posh-git"
export PROMPT_COMMAND='__posh_git_ps1 "\n[\[\e[32m\]\u\[\e[m\]\[\e[34m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]] " "\n\\$ ";'

# paths
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# asdf
export ASDF_DIR="$HOME/.asdf"
if [[ -s "$ASDF_DIR/asdf.sh" ]] ; then
  . "$ASDF_DIR/asdf.sh"
  [ -s "$ASDF_DIR/completions/asdf.bash" ] && . "$ASDF_DIR/completions/asdf.bash"
  asdf global nodejs 11.7.0
  asdf global ruby 2.6.0
  export PATH="./node_modules/.bin:$PATH"
fi

# rust
if [[ -d "$HOME/.cargo" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# git auto complete
[ -s "$HOME/.bash/git-completion" ] && "$HOME/.bash/git-completion"

# go
[ -s "$HOME/.gvm/scripts/gvm" ] && . "$HOME/.gvm/scripts/gvm"

# bash aliases
[ -s "$HOME/.bash/functions" ] && . "$HOME/.bash/functions"
[ -s "$HOME/.bash/aliases" ] && . "$HOME/.bash/aliases"

# keychain
[ -s "$HOME/.bash/ssh_agent" ] && source "$HOME/.bash/ssh_agent"

# mount network share at work
[ -s "$HOME/.bash/mount_network_share" ] && source "$HOME/.bash/mount_network_share"

# start broot and let it change directory
function br {
    f=$(mktemp)

    (
  set +e
  broot --out "$f" "$@"
  code=$?
  if [ "$code" != 0 ]; then
      rm -f "$f"
      exit "$code"
  fi
    )
    code=$?
    if [ "$code" != 0 ]; then
  return "$code"
    fi

    d=$(cat "$f")
    rm -f "$f"

    if [ "$(wc -c <(echo -n "$d") | head -c1)" != 0 ]; then
  cd "$d"
    fi
}

# WSL starts in user profile dir, not home dir
cd
