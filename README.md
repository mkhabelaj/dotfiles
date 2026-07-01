# Personal Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and [mise](https://mise.jdx.dev/).

## Quick Start

```bash
# 1. Install mise
curl https://mise.run | sh

# 2. Clone & setup
git clone https://github.com/jacksonmkhabela/dotfiles.git ~/dotfiles && cd ~/dotfiles

# 3. Stow configs
stow nvim nvim-octo tmux herdr alacritty fish mise flo

# 4. Install dev tools
mise install
```

## Stow Packages

| Package | Config |
|---------|--------|
| `nvim` | Neovim |
| `nvim-octo` | Neovim PR-review instance (launch with `nvo`) |
| `tmux` | Tmux |
| `herdr` | Herdr terminal workspace manager |
| `alacritty` | Alacritty terminal |
| `fish` | Fish shell |
| `mise` | mise tool manager |
| `flo` | flo workflow TUI |

## What mise Installs

Defined in `mise/.config/mise/config.toml`:

| Category | Tools |
|----------|-------|
| **Languages** | node, go, rust |
| **Editor** | neovim |
| **Terminal** | tmux |
| **CLI Tools** | zoxide, lazygit, gum, sesh |
| **Dev Tools** | tree-sitter-cli, usage, harper-ls |

## PR Review (`nvim-octo`)

A standalone Neovim config dedicated to reviewing GitHub PRs with
[octo.nvim](https://github.com/pwntester/octo.nvim), isolated from `nvim` so its
keymaps can be flat. Launched via `NVIM_APPNAME=nvim-octo`.

```bash
nvo            # dashboard (no args); forwards any nvim args otherwise
```

Requires `gh` (authenticated). First launch clones plugins via `vim.pack`; run
`:Themify install` once for colorschemes. Grammar-checks review prose with
`harper-ls` (installed by mise).

**Launchers** (leader = `Space`): `l` PR list · `s` search · `c` checkout ·
`d` diff · `a` all actions · `r{s,r,c,x}` review start/resume/submit/discard.

**In a review** (localleader = `,`): `,ca` comment · `,sa` suggestion ·
`,vs` submit · `,rt` resolve · `]q`/`[q` next/prev file · `]h`/`[h` next/prev hunk.

## Stow Usage

```bash
# Install a package
stow nvim

# Remove a package
stow -D nvim

# Reinstall (after config changes)
stow -R nvim

# Dry run (preview changes)
stow -n nvim
```

Each directory mirrors your home directory structure:

```
dotfiles/
├── nvim/.config/nvim/       # → ~/.config/nvim/
├── nvim-octo/.config/nvim-octo/  # → ~/.config/nvim-octo/
├── tmux/.config/tmux/       # → ~/.config/tmux/
├── herdr/.config/herdr/     # → ~/.config/herdr/
├── alacritty/.config/alacritty/  # → ~/.config/alacritty/
├── fish/.config/fish/       # → ~/.config/fish/
├── mise/.config/mise/       # → ~/.config/mise/
└── flo/.config/flo/         # → ~/.config/flo/
```
