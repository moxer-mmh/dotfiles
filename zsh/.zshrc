export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

export EDITOR='nvim'
export VISUAL='nvim'

plugins=(git)

source $ZSH/oh-my-zsh.sh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#777777'

alias claude-dang='claude --dangerously-skip-permissions'

alias ls='lsd --color=auto --group-dirs=first'
alias la='lsd -A --color=auto --group-dirs=first'

# Unset Oh My Zsh's ll alias so our function can take precedence
unalias ll 2>/dev/null

# Custom ll command with cosmic cyberpunk table formatting (full grid)
ll() {
  # Cosmic cyberpunk colors
  local PURPLE=$'\033[38;5;141m'
  local CYAN=$'\033[38;5;51m'
  local PINK=$'\033[38;5;213m'
  local NEON_GREEN=$'\033[38;5;48m'
  local GREY=$'\033[38;5;242m'
  local RESET=$'\033[0m'
  local BOLD=$'\033[1m'
  
  # Box drawing characters (single line)
  local H='─' V='│'
  local TL='┌' TR='┐' BL='└' BR='┘'
  local CROSS='┼' T_DOWN='┬' T_UP='┴' T_RIGHT='├' T_LEFT='┤'
  
  # Column widths
  local W_NUM=3
  local W_NAME=25
  local W_TYPE=6
  local W_PERM=18
  local W_SIZE=10
  local W_DATE=18

  # Helper to repeat a string (UTF-8 safe)
  _rep() {
    local count=$1
    local char=$2
    local result=""
    for ((i=0; i<count; i++)); do
      result="${result}${char}"
    done
    printf "%s" "$result"
  }

  # Strip ANSI codes
  _clean() { echo "$1" | sed -E 's/\x1b\[[0-9;]*m//g'; }

  # Convert permission bits to readable text
  _perm_bits() {
    local r="$1" w="$2" x="$3"
    local result=""
    [[ $r == "r" ]] && result+="read"
    [[ $w == "w" ]] && { [[ -n $result ]] && result+=" "; result+="write"; }
    [[ $x == "x" || $x == "S" || $x == "T" ]] && { [[ -n $result ]] && result+=" "; result+="exec"; }
    printf "%s" "${result:--}"
  }

  # Convert permission string to readable format (owner only, since that's what matters)
  _perm_to_readable() {
    local perm="$1"
    
    # Owner permissions (most relevant)
    local owner=$(_perm_bits "${perm:1:1}" "${perm:2:1}" "${perm:3:1}")
    
    echo "$owner"
  }

  # Print top border
  printf "${CYAN}${TL}"
  _rep $W_NUM "$H"; printf "${T_DOWN}"
  _rep $W_NAME "$H"; printf "${T_DOWN}"
  _rep $W_TYPE "$H"; printf "${T_DOWN}"
  _rep $W_PERM "$H"; printf "${T_DOWN}"
  _rep $W_SIZE "$H"; printf "${T_DOWN}"
  _rep $W_DATE "$H"; printf "${TR}${RESET}\n"

  # Header row
  printf "${PURPLE}${V}${RESET}${BOLD}${NEON_GREEN}%-${W_NUM}s${RESET}" "#"
  printf "${PURPLE}${V}${RESET}${BOLD}${NEON_GREEN}%-${W_NAME}s${RESET}" "name"
  printf "${PURPLE}${V}${RESET}${BOLD}${NEON_GREEN}%-${W_TYPE}s${RESET}" "type"
  printf "${PURPLE}${V}${RESET}${BOLD}${NEON_GREEN}%-${W_PERM}s${RESET}" "permissions"
  printf "${PURPLE}${V}${RESET}${BOLD}${NEON_GREEN}%-${W_SIZE}s${RESET}" "size"
  printf "${PURPLE}${V}${RESET}${BOLD}${NEON_GREEN}%-${W_DATE}s${RESET}" "modified"
  printf "${PURPLE}${V}${RESET}\n"

  # Header separator
  printf "${CYAN}${T_RIGHT}"
  _rep $W_NUM "$H"; printf "${CROSS}"
  _rep $W_NAME "$H"; printf "${CROSS}"
  _rep $W_TYPE "$H"; printf "${CROSS}"
  _rep $W_PERM "$H"; printf "${CROSS}"
  _rep $W_SIZE "$H"; printf "${CROSS}"
  _rep $W_DATE "$H"; printf "${T_LEFT}${RESET}\n"

  # Process files with lsd
  local tmpfile=$(mktemp)
  /usr/bin/lsd -lA --blocks permission,size,date,name --no-symlink --color=never "$@" | tail -n +2 > "$tmpfile"

  local idx=0
  while IFS= read -r line; do
    local perms=$(echo "$line" | awk '{print $1}')
    local size=$(echo "$line" | awk '{print $2}')
    local unit=$(echo "$line" | awk '{print $3}')
    local date=$(echo "$line" | sed -E 's/^[^ ]+ +[^ ]+ +[^ ]+ +//' | rev | cut -d' ' -f2- | rev)
    local name=$(echo "$line" | rev | cut -d' ' -f1 | rev)
    
    # Convert permissions to readable format
    local readable_perms=$(_perm_to_readable "$perms")
    
    # Determine type
    local type="file"
    [[ $perms =~ ^d ]] && type="dir"
    [[ $perms =~ ^l ]] && type="link"
    
    # Color for name
    local name_color="$RESET"
    [[ $type == "dir" ]] && name_color="$CYAN"

    # Truncate name if too long
    local display_name="$name"
    if [[ ${#name} -gt $W_NAME ]]; then
      display_name="${name:0:$((W_NAME-3))}..."
    fi

    # Print data row
    printf "${PURPLE}${V}${RESET}${GREY}%-${W_NUM}s${RESET}" "$idx"
    printf "${PURPLE}${V}${RESET}${name_color}%-${W_NAME}s${RESET}" "$display_name"
    printf "${PURPLE}${V}${RESET}%-${W_TYPE}s${RESET}" "$type"
    printf "${PURPLE}${V}${RESET}${NEON_GREEN}%-${W_PERM}s${RESET}" "$readable_perms"
    printf "${PURPLE}${V}${RESET}${PINK}%-${W_SIZE}s${RESET}" "$size $unit"
    printf "${PURPLE}${V}${RESET}${CYAN}%-${W_DATE}s${RESET}" "$date"
    printf "${PURPLE}${V}${RESET}\n"
    
    idx=$((idx + 1))
  done < "$tmpfile"
  
  rm -f "$tmpfile"
  
  # Bottom border
  printf "${CYAN}${BL}"
  _rep $W_NUM "$H"; printf "${T_UP}"
  _rep $W_NAME "$H"; printf "${T_UP}"
  _rep $W_TYPE "$H"; printf "${T_UP}"
  _rep $W_PERM "$H"; printf "${T_UP}"
  _rep $W_SIZE "$H"; printf "${T_UP}"
  _rep $W_DATE "$H"; printf "${BR}${RESET}\n"
}

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

# bun completions
[ -s "/home/moxer_mmh/.bun/_bun" ] && source "/home/moxer_mmh/.bun/_bun"
export PATH="$HOME/flutter/bin:$PATH"

# Android SDK
#export JAVA_HOME=/usr/lib/jvm/java-25-openjdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export CHROME_EXECUTABLE=chromium

# opencode
export PATH=/home/moxer_mmh/.opencode/bin:$PATH
