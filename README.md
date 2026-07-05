# Personal Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and [mise](https://mise.jdx.dev/).

## Quick Start

```bash
# 1. Install mise
curl https://mise.run | sh

# 2. Clone & setup
git clone https://github.com/jacksonmkhabela/dotfiles.git ~/dotfiles && cd ~/dotfiles

# 3. Stow configs
stow nvim nvim-octo nvim-notes tmux herdr alacritty fish mise flo

# 4. Install dev tools
mise install
```

## Stow Packages

| Package | Config |
|---------|--------|
| `nvim` | Neovim |
| `nvim-octo` | Neovim PR-review instance (launch with `nvo`) |
| `nvim-notes` | Neovim writing / Obsidian-vault-aware notes instance (launch with `nvn`) |
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
| **CLI Tools** | zoxide, lazygit, gum, sesh, ripgrep |
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

## Notes / Writing (`nvim-notes`)

A standalone Neovim config optimized for long-form writing, with
[obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) for
wiki-links, daily notes, backlinks, and note search, isolated from `nvim` so
it can stay lean and prose-tuned. Launched via `NVIM_APPNAME=nvim-notes`.

```bash
nvn            # opens with the notes workspace; forwards any nvim args otherwise
```

The Obsidian workspace defaults to a placeholder path (`~/vaults`) — edit
`WORKSPACE_PATH` in `lua/config/plugins.lua` to point at your real vault.
Requires `ripgrep` (for search/completion). First launch clones plugins via
`vim.pack` (**must be run interactively** — the install confirmation prompt
can't be answered headlessly); run `:Themify install` once for colorschemes.
Grammar-checks prose with `harper-ls` (installed by mise).

**Notes** (leader = `Space`): `nn` new note · `nt` today's daily note ·
`nf` find/switch note · `ns` search notes · `nb` backlinks · `nl` follow
link · `nT` insert template. `zz`/`zZ` zen mode. `us`/`uw`/`uc` toggle
spell/wrap/word-count.

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
├── nvim-notes/.config/nvim-notes/  # → ~/.config/nvim-notes/
├── tmux/.config/tmux/       # → ~/.config/tmux/
├── herdr/.config/herdr/     # → ~/.config/herdr/
├── alacritty/.config/alacritty/  # → ~/.config/alacritty/
├── fish/.config/fish/       # → ~/.config/fish/
├── mise/.config/mise/       # → ~/.config/mise/
└── flo/.config/flo/         # → ~/.config/flo/
```
