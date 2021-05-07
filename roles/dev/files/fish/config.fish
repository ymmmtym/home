# alias
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'
alias grep 'grep --color=auto'
alias l ls
alias ll 'ls -l'
alias lla 'ls -al'
alias ls 'ls -FG'
alias tat 'tmux a -t'
alias tkt 'tmux kill-session -t'
alias tkt-all 'tmux kill-server'
alias tl 'tmux ls'
alias tnt 'tmux new -t'
alias d 'docker'
alias dc 'docker-compose'

# rbenv
set -x PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

# go
set -x GOROOT "/usr/local/opt/go/libexec"
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin