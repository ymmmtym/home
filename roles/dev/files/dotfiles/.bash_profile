# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

eval "$(rbenv init -)"
export PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.rbenv/shims"