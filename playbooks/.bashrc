# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

export HISTSIZE=10000
export HISTTIMEFORMAT="%h/%d/%y - %H:%M:%S "
export PS1='\[\033[01;31m\]\H \[\033[00m\]\W \$'
export PS2='>'
export PS4='+'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
