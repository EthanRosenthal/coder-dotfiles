# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

# Extra completion dirs have to go on fpath BEFORE oh-my-zsh, so that the single
# compinit run inside oh-my-zsh.sh picks them up (see the NOTE at the bottom).
[[ -d ~/.dc/completions ]] && fpath=(~/.dc/completions $fpath)

source $ZSH/oh-my-zsh.sh

# uv-managed Python env. This file only exists when uv was installed by its
# standalone installer; on the CoreWeave image uv is /usr/bin/uv and the file is
# absent, so guard it or every shell prints "no such file or directory".
[ -s "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

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

# NOTE: do not add a bare `compinit` here, and do not append to fpath below this
# line. $HOME is an NFS mount (CoreWeave PVC, mounted lookupcache=pos, so failed
# lookups are never cached). A compinit that has to rescan fpath does ~1650
# `autoload -r` resolutions, each walking the NFS fpath entries first -> ~13s per
# shell. This file used to end with `fpath=(...); compinit`, a second compinit
# whose dump count never matched again, so it rescanned on every startup and cost
# ~30s to open a terminal tab. oh-my-zsh.sh already runs compinit against a
# cached, zwc-compiled dump.
