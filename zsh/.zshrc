export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias ls='lsd --color=auto --group-dirs=first'
alias cat='bat --color=auto'
alias poff='poweroff'
alias rb='reboot'
alias cls='clear'
alias ll='ls -lah --color=auto'
alias la='ls -A'
alias rmd='rm -rf'
alias n='nvim'
alias py='python3'

eval "$(starship init zsh)"

# Java JDK Setup
export JAVA_HOME="/usr/lib/jvm/java-24-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"

# Created by `pipx` on 2025-06-20 20:53:09
export PATH="$PATH:/home/moxer_mmh/.local/bin"
