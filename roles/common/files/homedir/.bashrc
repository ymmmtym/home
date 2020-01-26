# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"

# User specific aliases and functions

# alias
alias l='ls'
alias ls='ls -FG'
alias ll='ls -l'
alias lla='ls -al'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# tmux
alias tnt="tmux new -t"
alias tat="tmux a -t"
alias tl="tmux ls"
alias tkt="tmux kill-session -t"
alias tkt-all="tmux kill-server"

# docker
alias d="docker"
alias dc="docker-compose"

# prompt
if [ $UID -eq 0 ]; then
    PS1="\[\033[31m\]\u@localhost\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@localhost\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi

