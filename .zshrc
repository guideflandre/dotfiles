# # =============================================================================
# # Welcome message
# # =============================================================================
if [[ "$TERM" == "xterm-kitty" ]]; then
    figlet -f ANSI_Shadow "CBIO"
    echo "   Deflandre Guillaume"
fi

# =============================================================================
# =============================================================================
# =============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc

# =============================================================================
# OH MY ZSH
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# =============================================================================
# HISTORY
# =============================================================================
HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY

# =============================================================================
# ALIASES
# =============================================================================
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# =============================================================================
# Exit yazi and go to that directory
# =============================================================================
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
# =============================================================================
# PATH & ENVIRONMENT
# =============================================================================
export PATH="$PATH:/home/guillaumedeflandre/.local/bin"
export PATH="$PATH:/home/guillaumedeflandre/neovim/bin"

# Cargo (Rust)
. "$HOME/.cargo/env"

# Rapp
export PATH="$(Rscript -e 'cat(system.file("exec", package = "Rapp"))'):$PATH"

# Suppress Neovim core debug logs
export NVIM_LOG_LEVEL=3

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


