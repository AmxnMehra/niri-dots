# -------------------------------
# Homebrew (safe fallback)
# -------------------------------
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# -------------------------------
# Zinit Setup
# -------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# -------------------------------
# Plugins (optimized turbo mode)
# -------------------------------
zinit wait lucid for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab

# Oh-My-Zsh snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# -------------------------------
# Completion System (cached)
# -------------------------------
autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

zinit cdreplay -q

# -------------------------------
# Keybindings
# -------------------------------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# -------------------------------
# History Configuration
# -------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -------------------------------
# Completion Styling
# -------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# -------------------------------
# Aliases
# -------------------------------
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

alias n='nvim'
alias e='exit'
alias c='clear'
alias lg='lazygit'

# -------------------------------
# FZF Setup (IMPORTANT: before bindings)
# -------------------------------
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Custom FZF file opener (moved to different key to avoid conflict)
fzf_open_file() {
  local file
  file=$(fd --hidden --exclude .git | fzf --preview 'bat --color=always --line-range :300 {}') && nvim "$file"
  zle reset-prompt
}
zle -N fzf_open_file
bindkey '^O' fzf_open_file   # changed from Ctrl+T

# FZF UI
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "

# -------------------------------
# Smart directory jumping
# -------------------------------
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# -------------------------------
# PATH (safe way)
# -------------------------------
path+=("$HOME/.spicetify")

# -------------------------------
# Starship Prompt (MUST BE LAST)
# -------------------------------
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# -------------------------------
# Syntax Highlighting (ALWAYS LAST)
# -------------------------------
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
