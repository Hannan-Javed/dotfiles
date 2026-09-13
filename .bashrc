#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Disable history if running inside Dolphin's terminal wrapper
if [ "$COLORTERM" = "truecolor" ] && [ -n "$DOLPHIN_SELECTION" ] || [[ "$(ps -o comm= $PPID)" == *"dolphin"* ]]; then
    unset HISTFILE
fi

fastfetch
