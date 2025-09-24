# My Personal Dotfiles

This repository contains my personal dotfiles and application configurations. The goal is to have a consistent, efficient, and personalized development environment that can be easily set up on macOS and WSL Ubuntu.

## Platform Support

| Tool | macOS | WSL Ubuntu | Notes |
|------|-------|------------|--------|
| Zsh | ✅ | ✅ | Cross-platform shell |
| Neovim | ✅ | ✅ | Text editor with Lua config |
| Tmux | ✅ | ✅ | Terminal multiplexer |
| Alacritty | ✅ | ✅ | GPU-accelerated terminal |
| Ghostty | ✅ | ⚠️ | Limited Linux support |
| Aerospace | ✅ | ❌ | macOS-only window manager |
| Git & Lazygit | ✅ | ✅ | Version control tools |
| Core utilities (eza, zoxide, fzf, ripgrep) | ✅ | ✅ | Modern CLI replacements |

**Legend:**
- ✅ Fully supported
- ⚠️ Limited/alternative support available  
- ❌ Platform-specific, alternatives suggested

## What's Inside?

This collection manages the configuration for the following applications:

### Core Development Tools
-   **Shell:** Zsh with Oh My Zsh framework and oh-my-posh prompt
-   **Editor:** Neovim with comprehensive Lua configuration
-   **Multiplexer:** Tmux for session management
-   **Version Control:** Git with Lazygit TUI

### Terminal Applications  
-   **Terminal:** Alacritty (primary) & Ghostty (macOS)
-   **File Navigation:** Yazi file manager with modern alternatives (eza, zoxide, fzf)
-   **API Testing:** Posting HTTP client

### macOS-Specific Tools
-   **Window Manager:** Aerospace tiling window manager
-   
### Development Environment
-   **Languages:** Go, Python (pyenv), Node.js (nvm) support
-   **Package Managers:** Homebrew (macOS), apt (Ubuntu)
-   **Modern CLI Tools:** ripgrep, fd, jq, and more

## Prerequisites

### System Requirements
- **macOS:** 12.0+ (Monterey) or **WSL Ubuntu:** 20.04+
- **Terminal:** Modern terminal with true color support
- **Fonts:** Nerd Font for icons (automatically installed)

### Package Managers
- **macOS:** [Homebrew](https://brew.sh/)
- **WSL Ubuntu:** apt (pre-installed)

## Installation

Choose your platform to get started:

### 📱 macOS Installation

Install Homebrew if you haven't already:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install all dependencies:

```bash
# Core Utilities
brew install git lazygit eza zoxide fzf ripgrep fd jq poppler imagemagick sevenzip

# Zsh & Prompt
brew install zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Neovim
brew install neovim

# Terminal Applications
brew install tmux alacritty yazi ffmpeg

# Fonts
brew install font-symbols-only-nerd-font

# macOS-specific tools
brew install --cask aerospace

# API Client
curl -LsSf https://astral.sh/uv/install.sh | sh

# Optional: Ghostty (if desired)
brew install --cask ghostty
```

### 🐧 WSL Ubuntu Installation

Update system packages:
```bash
sudo apt update && sudo apt upgrade -y
```

Install dependencies:
```bash
# Core utilities
sudo apt install -y git curl wget build-essential

# Modern CLI tools
sudo apt install -y zsh tmux neovim fzf ripgrep fd-find

# Install eza (modern ls replacement)
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update && sudo apt install -y eza

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Install oh-my-posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install Yazi file manager
cargo install --locked yazi-fm yazi-cli  # Requires Rust
# OR download binary from: https://github.com/sxyazi/yazi/releases

# Install Alacritty
sudo add-apt-repository ppa:aslatter/ppa -y
sudo apt update && sudo apt install -y alacritty

# Install lazygit
sudo add-apt-repository ppa:lazygit-team/release -y
sudo apt update && sudo apt install -y lazygit

# Install fonts
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
```

### 🔧 Setup Configuration Files

After installing dependencies on either platform:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jacksonmkhabela/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the automated setup:**
   ```bash
   # For macOS
   ./install-mac.sh
   
   # For WSL Ubuntu  
   ./install-wsl.sh
   ```

3. **Or manually setup with GNU Stow:**
   ```bash
   # Install GNU Stow first
   # macOS: brew install stow
   # Ubuntu: sudo apt install stow
   
   # Stow individual packages
   stow zsh        # Links .zshrc
   stow tmux       # Links .tmux.conf  
   stow nvim       # Links .config/nvim/
   stow alacritty  # Links .config/alacritty/
   stow posting    # Links .config/posting/
   
   # macOS-only packages
   stow aerospace  # macOS only
   stow ghostty    # Optional
   
   # Or stow everything at once (be careful with platform-specific configs)
   stow */
   ```

4. **Install shell framework and plugins:**
   ```bash
   # Install Oh My Zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   
   # Restart shell or source config
   source ~/.zshrc
   ```

5. **Setup development environments:**
   ```bash
   # Python environment manager
   curl https://pyenv.run | bash
   
   # Node.js version manager
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   ```

## 📋 Tool Details & Configuration

### Shell & Terminal
- **Zsh**: Modern shell with extensive plugin ecosystem
  - Framework: Oh My Zsh for plugin management
  - Prompt: oh-my-posh with Catppuccin theme
  - Features: Auto-suggestions, syntax highlighting, history search

### Development Tools
- **Neovim**: Highly configurable text editor
  - Plugin Manager: lazy.nvim
  - LSP: Built-in language server support for Go, Python, TypeScript, etc.
  - Features: Fuzzy finding, debugging, git integration, AI assistance
  
- **Tmux**: Terminal multiplexer for session management
  - Theme: Catppuccin mocha
  - Features: Session persistence, pane management, status bar

### File Management
- **Yazi**: Modern terminal file manager
  - Features: Preview, tabs, bookmarks, image support
  - Integrations: fzf, ripgrep, fd

- **Modern CLI Replacements**:
  - `eza` → replaces `ls` with colors and icons
  - `zoxide` → replaces `cd` with smart directory jumping
  - `fzf` → fuzzy finder for files, history, commands
  - `ripgrep` → faster `grep` alternative
  - `fd` → faster `find` alternative

### macOS-Specific
- **Aerospace**: Tiling window manager
  - Configuration: `~/.config/aerospace/aerospace.toml`
  - Workspaces: Keyboard-driven workspace management
  - Integration: Supports Sketchybar status updates

### Version Management
- **pyenv**: Python version management
- **nvm**: Node.js version management
- **Languages**: Go (built-in), Python, TypeScript/JavaScript, PHP, Lua

## 🔧 Post-Installation

### Essential Steps
1. **Restart your terminal** or run `source ~/.zshrc`
2. **Open Neovim** (`nvim`) to trigger automatic plugin installation
3. **Verify installations**:
   ```bash
   # Test shell features
   which zsh oh-my-posh eza zoxide fzf
   
   # Test development tools
   nvim --version
   tmux -V
   git --version
   
   # Test file tools
   yazi --version
   rg --version
   ```

### Configure Development Environments
```bash
# Install latest Python
pyenv install 3.11.0
pyenv global 3.11.0

# Install latest Node.js
nvm install node
nvm use node
```

## 🚨 Troubleshooting

### Common Issues

#### **Shell not loading properly**
```bash
# Check if zsh is default shell
echo $SHELL

# Change default shell to zsh
chsh -s $(which zsh)

# Reload shell configuration  
source ~/.zshrc
```

#### **Oh My Posh not found (WSL)**
```bash
# Add oh-my-posh to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### **Fonts not displaying correctly**
- **macOS**: Install Nerd Fonts via Homebrew: `brew install font-symbols-only-nerd-font`
- **WSL**: Install fonts in Windows and configure terminal:
  ```bash
  # Download and install fonts manually
  mkdir -p ~/.local/share/fonts
  # Copy JetBrains Mono Nerd Font to fonts directory
  fc-cache -fv
  ```

#### **Neovim plugins not loading**
```bash
# Open Neovim and run
:Lazy sync
:checkhealth
```

#### **Python/Node environments not working**
```bash
# Reload shell after installing pyenv/nvm
exec zsh

# Check installations
pyenv versions
nvm list
```

### WSL-Specific Issues

#### **GUI applications not working**
```bash
# Install VcXsrv or X410 on Windows
# Add to ~/.zshrc:
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
```

#### **File permissions issues**
```bash
# Fix Windows/WSL file permission differences
sudo umount /mnt/c
sudo mount -t drvfs C: /mnt/c -o metadata,uid=1000,gid=1000
```

### Performance Optimization

#### **Slow shell startup**
```bash
# Profile startup time
time zsh -i -c exit

# Disable unused plugins in ~/.zshrc
plugins=(git python) # Keep only essential ones
```

#### **Neovim performance**
- Reduce startup plugins by lazy-loading
- Check `:Lazy profile` for slow plugins
- Consider LSP server performance with `:LspInfo`

## 🔄 Updates & Maintenance

### Keep Everything Updated
```bash
# Update Homebrew packages (macOS)
brew update && brew upgrade

# Update apt packages (Ubuntu)
sudo apt update && sudo apt upgrade

# Update Neovim plugins
nvim -c "Lazy sync" -c "qa"

# Update Oh My Zsh
omz update
```

### Sync Dotfiles Changes
```bash
cd ~/.dotfiles
git pull origin main
source ~/.zshrc
```

## 🔗 About GNU Stow

This dotfiles setup uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management, which provides several advantages:

### Why Stow?
- **Clean Management**: Creates proper symlinks without manual `ln` commands
- **Easy Removal**: `stow -D package` cleanly removes all symlinks
- **Conflict Detection**: Warns about existing files before overwriting
- **Selective Installation**: Install only the packages you need per platform

### Common Stow Commands
```bash
# Install specific packages
stow zsh nvim tmux

# Remove a package
stow -D aerospace  # Removes all aerospace symlinks

# Reinstall a package (useful after config changes)
stow -R nvim

# Dry run (see what would happen)
stow -n zsh

# Verbose output
stow -v alacritty
```

### Package Structure
Each directory represents a "package" that mirrors your home directory structure:
```
dotfiles/
├── zsh/
│   └── .zshrc              # → ~/.zshrc
├── nvim/
│   └── .config/
│       └── nvim/          # → ~/.config/nvim/
└── alacritty/
    └── .config/
        └── alacritty/     # → ~/.config/alacritty/
```