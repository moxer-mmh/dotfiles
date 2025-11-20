export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

export EDITOR='nvim'
export VISUAL='nvim'

plugins=(git)

source $ZSH/oh-my-zsh.sh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777777'

alias ls='lsd --color=auto --group-dirs=first'
alias ll='ls -lah --color=auto'
alias la='ls -A'

#alias cat='bat --color=auto'
alias rmd='rm -rf'

alias poff='poweroff'
alias po='poweroff'
alias rb='reboot'
alias cls='clear'
alias ngpu='prime-run'

alias n='nvim'
alias y='yazi'
alias dt='cd ~/dotfiles && yazi .'
alias tdt="tmux new-session -A -s Dragon-Config \; send-keys -t Dragon-Config 'cd ~/dotfiles && yazi .' Enter \; attach-session -t Dragon-Config"Copied!
alias vl='cd ~/gdrive/Dragon-Vault && yazi .'
alias tvl="tmux new-session -A -s Dragon-Vault \; send-keys -t Dragon-Vault 'cd ~/gdrive/Dragon-Vault && yazi .' Enter \; attach-session -t Dragon-Vault"
alias ta='tmux attach'
alias tl='tmux ls'

to () {
  local name=$1
  local path=$2
  local cmd=$3
  /usr/bin/tmux new-session -A -s "$name" -c "$path" \; send-keys "$cmd" Enter
}

alias py='python3'

eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

export JAVA_HOME="/usr/lib/jvm/java-24-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"

export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

export PATH=$HOME/.local/bin:$PATH

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
