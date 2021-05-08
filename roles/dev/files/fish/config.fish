# fish
set -x fish_theme agnoster
function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'                                                                                                                                
  bind \c] peco_select_ghq_repository
end

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
alias g 'cd (ghq list --full-path | peco)'
alias hbg 'hub browse (ghq list | peco | cut -d "/" -f 2,3)'
alias gg 'ghq get -p (curl -s "https://api.github.com/users/"(git config user.name)"/repos?per_page=100" | jq -r ".[].full_name" | peco)'


# rbenv
set -x PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

# go
set -x GOROOT "/usr/local/opt/go/libexec"
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin