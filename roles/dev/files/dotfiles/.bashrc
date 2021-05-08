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
alias tnt="tmux new -t"
alias tat="tmux a -t"
alias tl="tmux ls"
alias tkt="tmux kill-session -t"
alias tkt-all="tmux kill-server"
alias d="docker"
alias dc="docker-compose"
alias g='cd $(ghq list --full-path | peco)'
alias hbg='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias gg='ghq get -p $(curl -s "https://api.github.com/users/$(git config user.name)/repos?per_page=100" | jq -r ".[].full_name" | peco)'

# git
source /usr/local/etc/bash_completion.d/git-prompt.sh &>/dev/null
source /usr/local/etc/bash_completion.d/git-completion.bash &>/dev/null

# prompt
if [ $UID -eq 0 ]; then
    # prompt of root user
    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi
