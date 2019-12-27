#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias hibernate='swaylock & systemctl hibernate'
#PS1='[\u@\h \W]\$ '

export PS1="\n\033[1;31m[ \033[0;31m\w \033[1;31m]\n > \[$(tput sgr0)\]"
