# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export PATH="/Users/jacksonmkhabela/.local/bin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# Build plugins array based on what's installed
plugins=(git)  # git is always available

# Only add python plugin if python is available
if command -v python &> /dev/null || command -v python3 &> /dev/null; then
    plugins+=(python)
fi

# Only add pyenv plugin if pyenv will be available
if [[ -d "$HOME/.pyenv/bin" ]] || command -v pyenv &> /dev/null; then
    plugins+=(pyenv)
fi

# Automatically activate virtualenvs (only if python plugin loaded)
export PYTHON_AUTO_VRUN=true

# Load Oh My Zsh if available
if [[ -f $ZSH/oh-my-zsh.sh ]]; then
    source $ZSH/oh-my-zsh.sh
else
    echo "⚠️  Oh My Zsh not found. Install: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# ---- Custom Aliases for Sesh ----
if command -v sesh &> /dev/null && command -v gum &> /dev/null; then
    alias s='sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder '\''Pick a sesh'\'' --prompt='\''⚡'\'')"'
    alias sg='sesh connect "$(sesh list -i | gum filter --limit 1 --placeholder '\''Pick a sesh'\'' --prompt='\''⚡'\'')"'
fi

if command -v sesh &> /dev/null && command -v fzf &> /dev/null; then
    alias sf='sesh connect "$(sesh list -i | fzf)"'
fi
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# OS-specific configurations loaded from ~/.osZsh
# Copy macOSZsh or ubuntuWSLZsh to ~/.osZsh based on your platform
if [[ -f ~/.osZsh ]]; then
    source ~/.osZsh
else
    echo "⚠️  No OS profile found. Copy macOSZsh or ubuntuWSLZsh to ~/.osZsh"
fi

# ---- For Yazy setup ----
export EDITOR=nvim

# ---- Go setup ----
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# ---- zoxide setup ----
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
else
    echo "⚠️  zoxide not found. Install: curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh"
fi

# ---- fzf setup ----
# fzf initialization handled in OS-specific profiles
# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


export FZF_DEFAULT_OPTS='--ansi'


# OS-specific plugin loading handled in OS profiles

# ---- Eza (better ls) -----
if command -v eza &> /dev/null; then
    alias ls="eza --icons=always"
fi

# A better cd
if command -v zoxide &> /dev/null; then
    alias cd="z"
fi

# pyenv setup
# alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
# echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
# echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
# echo 'eval "$(pyenv init -)"' >> ~/.zshrc
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# In dotfiles/zsh/.zshrc
if [ -f ~/.zshrc_secrets ]; then
  source ~/.zshrc_secrets
fi

# oh-my-posh configuration handled in OS profiles

# Task Master aliases added on 2025-08-16
alias tm='task-master'
alias taskmaster='task-master'

# ========================================
# CUSTOM USER CONFIGURATION
# ========================================

# Load custom user/environment-specific configurations
# Copy customZsh.template to ~/.customZsh and customize for your needs
if [[ -f ~/.customZsh ]]; then
    source ~/.customZsh
else
    # Provide helpful message on first run
    if [[ ! -f ~/.customZsh_notified ]]; then
        echo "💡 Tip: Copy ~/dotfiles/zsh/customZsh.template to ~/.customZsh for custom configurations"
        touch ~/.customZsh_notified
    fi
fi
