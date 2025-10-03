#!/bin/bash

# WSL Ubuntu Dotfiles Installation Script
# Automates the setup of dotfiles on WSL Ubuntu

set -e  # Exit on any error

echo "🐧 Setting up dotfiles for WSL Ubuntu..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on WSL
if ! grep -q microsoft /proc/version 2>/dev/null; then
    print_warning "This script is optimized for WSL. Continuing anyway..."
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install core dependencies
print_status "Installing core dependencies..."
sudo apt install -y git curl wget build-essential zsh tmux fzf ripgrep fd-find stow fuse

# Install modern CLI tools
print_status "Installing modern CLI alternatives..."

# Install eza (modern ls replacement)
if ! command -v eza &> /dev/null; then
    print_status "Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update && sudo apt install -y eza
else
    print_success "eza already installed"
fi

# Install zoxide
if ! command -v zoxide &> /dev/null; then
    print_status "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
else
    print_success "zoxide already installed"
fi

# Install oh-my-posh
if ! command -v oh-my-posh &> /dev/null; then
    print_status "Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
else
    print_success "oh-my-posh already installed"
fi

# Install Rust (needed for some tools)
if ! command -v cargo &> /dev/null; then
    print_status "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
else
    print_success "Rust already installed"
fi

# Install Yazi file manager
if ! command -v yazi &> /dev/null; then
    print_status "Installing Yazi file manager..."
    cargo install --locked yazi-fm yazi-cli
else
    print_success "Yazi already installed"
fi

# Install Alacritty
print_status "Installing Alacritty terminal..."
if ! command -v alacritty &> /dev/null; then
    sudo add-apt-repository ppa:aslatter/ppa -y
    sudo apt update && sudo apt install -y alacritty
else
    print_success "Alacritty already installed"
fi

# Install lazygit (manual installation - no PPA available)
if ! command -v lazygit &> /dev/null; then
    print_status "Installing lazygit from GitHub releases..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
else
    print_success "lazygit already installed"
fi

# Install latest Neovim (AppImage for latest version)
if ! command -v nvim &> /dev/null || [[ $(nvim --version | head -n1 | grep -o '[0-9]\+\.[0-9]\+' | head -n1) < "0.9" ]]; then
    print_status "Installing latest Neovim..."
    if curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage; then
        chmod u+x nvim-linux-x86_64.appimage
        sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
        # Create symlink for backward compatibility
        sudo ln -sf /usr/local/bin/nvim /usr/local/bin/neovim 2>/dev/null || true
        print_success "Latest Neovim installed via AppImage"
    else
        print_warning "AppImage download failed, installing from apt..."
        sudo apt install -y neovim
    fi
else
    print_success "Neovim already installed with sufficient version"
fi

# Install fonts
print_status "Installing Nerd Fonts..."
mkdir -p ~/.local/share/fonts
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
rm JetBrainsMono.zip
cd -

# Create necessary directories
print_status "Creating configuration directories..."
mkdir -p ~/.config

# Backup existing configs
backup_dir="$HOME/dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
if [[ -f ~/.zshrc ]] || [[ -f ~/.tmux.conf ]] || [[ -d ~/.config/nvim ]]; then
    print_warning "Backing up existing configurations to $backup_dir"
    mkdir -p "$backup_dir"
    
    [[ -f ~/.zshrc ]] && cp ~/.zshrc "$backup_dir/"
    [[ -f ~/.tmux.conf ]] && cp ~/.tmux.conf "$backup_dir/"
    [[ -d ~/.config/nvim ]] && cp -r ~/.config/nvim "$backup_dir/"
    [[ -d ~/.config/alacritty ]] && cp -r ~/.config/alacritty "$backup_dir/"
fi

# Create symlinks using GNU Stow
print_status "Creating symbolic links with GNU Stow..."

# Stow essential configs (cross-platform)
stow zsh tmux nvim alacritty posting

# Copy WSL Ubuntu-specific zsh profile
print_status "Setting up WSL Ubuntu Zsh profile..."
cp ~/dotfiles/zsh/ubuntuWSLZsh ~/.osZsh
print_success "WSL Ubuntu Zsh profile installed as ~/.osZsh"

# Skip macOS-specific configs
print_warning "Skipping macOS-specific configurations (Aerospace, Sketchybar)"
print_success "All configurations linked with Stow"

# Install Oh My Zsh if not present
if [[ ! -d ~/.oh-my-zsh ]]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_success "Oh My Zsh already installed"
fi

# Install development environment managers
print_status "Setting up development environments..."

# Python environment manager
if ! command -v pyenv &> /dev/null; then
    print_status "Installing pyenv..."
    curl https://pyenv.run | bash
else
    print_success "pyenv already installed"
fi

# Node.js version manager
if [[ ! -d ~/.nvm ]]; then
    print_status "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
else
    print_success "nvm already installed"
fi

# Change default shell to zsh
print_status "Changing default shell to zsh..."
if [[ "$SHELL" != *"zsh"* ]]; then
    chsh -s $(which zsh)
    print_success "Default shell changed to zsh"
else
    print_success "zsh is already the default shell"
fi

print_success "🎉 WSL Ubuntu dotfiles setup complete!"
print_status "Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Run: source ~/.zshrc"
echo "  3. Open Neovim to install plugins automatically"
echo "  4. Install Python/Node versions with pyenv/nvm as needed"
echo "  5. Consider installing a tiling window manager for Linux (i3, sway, etc.)"

if [[ -d "$backup_dir" ]]; then
    print_warning "Your old configurations were backed up to: $backup_dir"
fi

print_warning "WSL-specific notes:"
echo "  • Window management tools (Aerospace) are not available"
echo "  • Some GUI applications may require X11 forwarding"
echo "  • Font rendering may need additional configuration"
