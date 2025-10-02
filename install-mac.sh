#!/bin/bash

# macOS Dotfiles Installation Script
# Automates the setup of dotfiles on macOS

set -e  # Exit on any error

echo "🍎 Setting up dotfiles for macOS..."

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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only. Use install-wsl.sh for WSL Ubuntu."
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    print_success "Homebrew is already installed"
fi

# Update Homebrew
print_status "Updating Homebrew..."
brew update

# Install dependencies
print_status "Installing dependencies..."
brew install git lazygit eza zoxide fzf ripgrep fd jq poppler imagemagick sevenzip
brew install zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew install neovim tmux alacritty yazi ffmpeg stow
brew install font-symbols-only-nerd-font

# Install macOS-specific tools
print_status "Installing macOS-specific tools..."
brew install --cask aerospace

# Optional installations
read -p "Install Ghostty terminal? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install --cask ghostty
fi

# Install API client
print_status "Installing Posting API client..."
curl -LsSf https://astral.sh/uv/install.sh | sh

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
    [[ -d ~/.config/aerospace ]] && cp -r ~/.config/aerospace "$backup_dir/"
fi

# Create symlinks using GNU Stow
print_status "Creating symbolic links with GNU Stow..."

# Stow essential configs
stow zsh tmux nvim alacritty posting

# Stow macOS-specific configs
stow aerospace

# Optional Ghostty config
if [[ -d ~/dotfiles/ghostty ]]; then
    print_status "Stowing Ghostty configuration..."
    stow ghostty
fi

# Copy macOS-specific zsh profile
print_status "Setting up macOS Zsh profile..."
cp ~/dotfiles/zsh/macOSZsh ~/.osZsh
print_success "macOS Zsh profile installed as ~/.osZsh"

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

print_success "🎉 macOS dotfiles setup complete!"
print_status "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open Neovim to install plugins automatically"
echo "  3. Configure Aerospace window manager settings"
echo "  4. Install Python/Node versions with pyenv/nvm as needed"

if [[ -d "$backup_dir" ]]; then
    print_warning "Your old configurations were backed up to: $backup_dir"
fi
