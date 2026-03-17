#!/bin/bash

# Only run once — skip if we've already set up this workspace
if [ -f "$HOME/.dotfiles-installed" ]; then
  exit 0
fi

cp gitconfig ~/.gitconfig

# Zsh Shell
add-apt-repository -y ppa:git-core/ppa
apt -y update && apt -y upgrade
apt -y install build-essential \
                curl git xclip htop tree nano
apt install -y zsh
chsh -s $(which zsh)

# Ensure zsh starts on login even if chsh doesn't stick (e.g. containers)
grep -q "exec zsh" ~/.bashrc 2>/dev/null || cat >> ~/.bashrc << 'BASHEOF'
if [ -x "$(command -v zsh)" ]; then
  exec zsh
fi
BASHEOF

# Oh My Zsh installation
echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install clean zshrc (overwrite whatever OMZ generated)
cp "$(dirname "$0")/zshrc" ~/.zshrc

# brew (activate for remainder of this script)
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
BREW_SHELLENV="eval \"\$($(brew --prefix)/bin/brew shellenv)\""
grep -qF "brew shellenv" ~/.bashrc 2>/dev/null || echo "$BREW_SHELLENV" >> ~/.bashrc

brew install docker
brew install k9s
brew install node

# Allow pip to install packages system-wide (workaround for PEP 668)
mkdir -p /etc
cat > /etc/pip.conf << 'PIPEOF'
[global]
break-system-packages = true
PIPEOF
mkdir -p ~/.config/pip
cat > ~/.config/pip/pip.conf << 'PIPEOF'
[global]
break-system-packages = true
PIPEOF

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
claude plugin marketplace update claude-plugins-official || true
claude plugin install pyright-lsp || true
claude plugin enable pyright-lsp || true

# Mark setup as complete
touch "$HOME/.dotfiles-installed"
