# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

# rbenv
eval "$(rbenv init -)"
export PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.rbenv/shims"

# go
export GOROOT="go env GOROOT" or "/usr/local/opt/go/libexec"
export GOPATH=$HOME/dev/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin