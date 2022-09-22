export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

ZSH_THEME="bira"
ENABLE_CORRECTION="true"

source $ZSH/oh-my-zsh.sh

if [ -f "$HOME/.motd" ]
then
    MOTD=$(cat "$HOME/.motd")
    echo $fg[blue]$MOTD\\n
fi
