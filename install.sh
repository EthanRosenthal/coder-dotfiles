#!/bin/bash

# Only run once — skip if we've already set up this workspace
if [ -f "$HOME/.dotfiles-installed" ]; then
  exec zsh
fi

cp gitconfig ~/.gitconfig

# Zsh Shell
apt -y update && apt -y upgrade
apt -y install build-essential \
                curl git xclip htop tree nano
apt install -y zsh
chsh -s $(which zsh)

# Oh My Zsh installation
echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Terminal
echo "COLORTERM=truecolor" >> ~/.zshrc

# brew
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc

brew install docker
brew install k9s
brew install node

# Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Python LSP for Claude Code
npm install -g pyright
mkdir -p ~/.claude
cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "ENABLE_LSP_TOOL": "1"
  },
  "enabledPlugins": {
    "pyright-lsp@claude-plugins-official": true
  }
}
EOF
echo "export ENABLE_LSP_TOOL=1" >> ~/.zshrc
claude plugin marketplace update claude-plugins-official
claude plugin install pyright-lsp
claude plugin enable pyright-lsp

# Mark setup as complete
touch "$HOME/.dotfiles-installed"

exec zsh
