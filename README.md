# My Personal Dotfiles

This repository contains my personal dotfiles and application configurations. The goal is to have a consistent, efficient, and personalized development environment that can be easily set up on a new macOS machine.

## What's Inside?

This collection manages the configuration for the following applications:

-   **Shell:** Zsh, configured via `.zshrc` with Oh My Zsh.
-   **Terminal:** Alacritty & Ghostty
-   **Editor:** Neovim (configuration is in `nvim/`)
-   **Window Manager:** Aerospace
-   **Status Bar:** Sketchybar
-   **Multiplexer:** Tmux
-   **API Client:** Posting
-   **Other Tools:** Git, Lazygit, etc.

## Prerequisites

Before you begin, you'll need [Homebrew](https://brew.sh/) to install the necessary packages.

Once Homebrew is installed, you can install all dependencies with the following commands:

```bash
# Core Utilities
brew install git lazygit eza zoxide fzf ripgrep fd jq poppler imagemagick sevenzip

# Zsh & Prompt
brew install zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Neovim
brew install neovim

# Terminal File Manager
brew install yazi ffmpeg font-symbols-only-nerd-font

# API Client
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
    ```

2.  **Navigate to the directory:**

    ```bash
    cd ~/.dotfiles
    ```

3.  **Symlink the configuration files:**

    The following commands will create symbolic links from your home directory to the configuration files in this repository.

    ```bash
    # Zsh
    ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc

    # Tmux
    ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

    # Alacritty
    ln -s ~/.dotfiles/alacritty/.config/alacritty ~/.config/alacritty

    # Ghostty
    ln -s ~/.dotfiles/ghostty/.config/ghostty ~/.config/ghostty

    # Neovim
    ln -s ~/.dotfiles/nvim/.config/nvim ~/.config/nvim

    # Aerospace
    ln -s ~/.dotfiles/aerospace/.config/aerospace ~/.config/aerospace

    # Sketchybar
    ln -s ~/.dotfiles/sketchybar/.config/sketchybar ~/.config/sketchybar

    # Posting
    ln -s ~/.dotfiles/posting/.config/posting ~/.config/posting
    ```

    **Note:** If you already have existing configuration files (e.g., a `.zshrc`), you will need to back them up or remove them before creating the symbolic links.

4.  **Install Zsh & Neovim plugins:**

    -   **Oh My Zsh:** The Zsh configuration depends on it. You can install it with the command on their [website](https://ohmyzsh.com/).
    -   **Neovim:** Open Neovim (`nvim`) and the `lazy.nvim` plugin manager should automatically install all the required plugins.

## Post-Installation

After setting everything up, you should restart your terminal or run `source ~/.zshrc` to apply the new Zsh configuration.