export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias ls='lsd --color=auto --group-dirs=first'
alias ll='ls -lah --color=auto'
alias la='ls -A'

#alias cat='bat --color=auto'
alias rmd='rm -rf'

alias poff='poweroff'
alias po='poweroff'
alias rb='reboot'
alias cls='clear'

alias n='nvim'
alias py='python3'

eval "$(starship init zsh)"

export JAVA_HOME="/usr/lib/jvm/java-24-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

export PATH=$HOME/.local/bin:$PATH

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

