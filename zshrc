# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# uv-managed Python env
. "$HOME/.local/bin/env"

# Linuxbrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Ensure ~/.local/bin takes precedence over linuxbrew (e.g. for python3 symlinks)
export PATH="/root/streaming-inference/.venv/bin:$HOME/.local/bin:$PATH"

export COLORTERM=truecolor
export ENABLE_LSP_TOOL=1

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# dc shell completions
fpath=(~/.dc/completions $fpath)
autoload -Uz compinit && compinit
