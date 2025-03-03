#!/bin/bash

cp gitconfig ~/.gitconfig

# Zsh Shell
apt -y update && apt -y upgrade
apt -y install build-essential \
                curl git xclip htop tree nano
apt install -y zsh
chsh -s $(which zsh)

# Oh My Zsh installation
echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# brew
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc

brew install docker
brew install k9s


exec zsh
source ~/.zshrc
