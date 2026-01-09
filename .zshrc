# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Add cargo bin to PATH (same as fish)
export PATH="$HOME/.cargo/bin:$PATH"

export ZSH="/usr/share/oh-my-zsh"

# Use Starship prompt instead of Oh My Zsh theme
# ZSH_THEME="agnosterzak"

plugins=( 
    git
    dnf
)

source $ZSH/oh-my-zsh.sh

# Load system-wide syntax highlighting and autosuggestions (like fish)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Initialize Starship prompt (same as fish)
eval "$(starship init zsh)"

# Ensure same behavior as fish
setopt PROMPT_SUBST
setopt INTERACTIVECOMMENTS
setopt AUTO_CD                 # cd by typing directory name if it's not a command
setopt CORRECT                 # command auto-correction
setopt MENU_COMPLETE          # automatically highlight first element of completion menu
setopt AUTO_LIST              # automatically list choices on ambiguous completion
setopt COMPLETE_IN_WORD       # complete from both ends of a word

# Configure autosuggestions (like fish)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#666666'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# check the dnf plugins commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dnf


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# quickshell sequences (same as fish)
if [[ -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt ]]; then
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
fi

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/directories in terminal using lsd
# Use eza
alias ls='eza --icons'
alias l='eza --icons -l --header --time-style=long-iso'
alias la='eza --icons -a'
alias ll='eza --icons -la --header --time-style=long-iso'
alias lla='eza --icons -la --header --time-style=long-iso'
alias lt='eza --icons --tree'

# Fallback for servers without eza
if ! command -v eza &>/dev/null; then
  alias ls='ls --color=auto --group-directories-first'
fi

# Additional aliases from fish config
alias pamcan='pacman'
alias clear="printf '\033[2J\033[3J\033[1;1H'"
alias ssh='TERM=xterm-256color ssh'
alias q='qs -c ii'

# Set Neovim as default editor
export EDITOR=nvim
export VISUAL=nvim

# GRC - colorize standard command outputs
if command -v grc &>/dev/null; then
  alias df='grc df'
  alias ping='grc ping'
  alias netstat='grc netstat'
  alias traceroute='grc traceroute'
  alias head='grc head'
  alias tail='grc tail'
  alias ps='grc ps'
  alias dig='grc dig'
  alias mount='grc mount'
  alias ifconfig='grc ifconfig'
fi


  # Moderner, gut lesbarer Ersatz für ifconfig
  alias ipa="ip -c a | awk 'NR>1 && /^[0-9]+:/ { print \"\" } {print}'"

. "$HOME/.local/bin/env"

# Live timer in window title
if [[ -f "$HOME/.zsh_live_timer.zsh" ]]; then
    source "$HOME/.zsh_live_timer.zsh"
fi


# --- Server Mount Funktionen ---

# Mounten: mnt user@ip:/pfad [name]
function mnt() {
    local REMOTE=$1
    local NAME=${2:-remote}        # Wenn kein Name, nenne Ordner "remote"
    local TARGET="$HOME/Mounts/$NAME"

    # Ordner erstellen, falls nicht da
    mkdir -p "$TARGET"

    # Mounten mit CachyOS-freundlichen Performance-Flags
    sshfs "$REMOTE" "$TARGET" -o reconnect,ServerAliveInterval=15,compression=yes,auto_cache,Ciphers=chacha20-poly1305@openssh.com

    if [ $? -eq 0 ]; then
        echo "✅ Connected: $TARGET"
    else
        echo "❌ Error while connecting"
        rmdir "$TARGET" 2>/dev/null
    fi
}

# Unmounten: umnt [name]
function umnt() {
    local NAME=${2:-remote}
    local TARGET="$HOME/Mounts/$NAME"

    fusermount -u "$TARGET" && echo "🔌 Disconnected" && rmdir "$TARGET" 2>/dev/null
}
