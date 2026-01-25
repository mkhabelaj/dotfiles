# Personal Dotfiles

Personal dotfiles with [mise](https://mise.jdx.dev/) for cross-platform development setup. One config file installs all development tools across any platform (Arch, Ubuntu, WSL, macOS).

## Quick Start

```bash
# 1. Install mise (works on Linux, macOS, WSL)
curl https://mise.run | sh

# 2. Clone & setup
git clone https://github.com/jacksonmkhabela/dotfiles.git ~/dotfiles && cd ~/dotfiles
stow mise

# 3. Install all dev tools
mise install
```

This gives you: neovim, tmux, node, go, python, rust, fzf, ripgrep, fd, lazygit, eza, zoxide, yazi, sesh, gum, bat, tldr, tree-sitter-cli, and claude-code.

## What mise Installs

All tools are defined in `mise/.config/config.toml`:

| Category | Tools |
|----------|-------|
| **Languages** | node, rust, go, python |
| **Editor** | neovim |
| **Terminal** | tmux |
| **CLI Tools** | eza, zoxide, fzf, ripgrep, fd, lazygit, bat, tldr |
| **Dev Tools** | sesh, gum, yazi, tree-sitter-cli, claude-code |

## Application Configs

Stow packages for application configurations:

```bash
# Core configs
stow nvim       # Neovim config
stow tmux       # Tmux config
stow zsh        # Zsh shell config

# Terminals
stow alacritty  # Alacritty terminal
stow ghostty    # Ghostty terminal (alternative)

# Tools
stow sesh       # Session manager config
stow posting    # HTTP client config
```

## OS-Specific Configs

### Arch Linux / Hyprland

Desktop environment configs for Hyprland:

```bash
stow hypr       # Hyprland window manager + hyprlock
stow waybar     # Status bar
stow wofi       # App launcher
```

## Stow Usage

[GNU Stow](https://www.gnu.org/software/stow/) manages symlinks from this repo to your home directory.

```bash
# Install packages
stow nvim tmux alacritty

# Remove a package
stow -D nvim

# Reinstall (after config changes)
stow -R nvim

# Dry run (preview changes)
stow -n nvim

# Install stow if needed
# Arch: sudo pacman -S stow
# Ubuntu: sudo apt install stow
# macOS: brew install stow
```

Each directory mirrors your home directory structure:
```
dotfiles/
├── nvim/
│   └── .config/
│       └── nvim/          # → ~/.config/nvim/
├── tmux/
│   └── .config/
│       └── tmux/          # → ~/.config/tmux/
└── mise/
    └── .config/
        └── config.toml    # → ~/.config/config.toml
```
