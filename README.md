# Personal Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and [mise](https://mise.jdx.dev/).

## Quick Start

```bash
# 1. Install mise
curl https://mise.run | sh

# 2. Clone & setup
git clone https://github.com/jacksonmkhabela/dotfiles.git ~/dotfiles && cd ~/dotfiles

# 3. Stow configs
# Use `mise` on a work machine (no AI tools), or `mise-omarc` on a personal
# omarchy machine (merges with the AI tools omarchy installs globally).
# Stow only one of the two -- they both target ~/.config/mise/config.toml.
stow nvim nvim-octo nvim-notes tmux herdr ghostty fish mise flo visidata

# On a personal omarchy machine, also stow hypr and omarchy (see "Hyprland
# (`hypr`)" and "Herdr learn menu" below).

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
| `ghostty` | Ghostty terminal (GPU, inline images) |
| `hypr` | Hyprland user overrides (omarchy machines only; `monitors.lua` is gitignored) |
| `omarchy` | Omarchy menu extension only (omarchy machines only): Learn > Herdr row -> `herdr-learn.py`; Personal > Notes -> today's note in `nvn` |
| `fish` | Fish shell |
| `mise` | mise tool manager (work machines, no AI tools) |
| `mise-omarc` | mise tool manager (personal omarchy machines, merges omarchy's AI tools) |
| `flo` | flo workflow TUI |
| `visidata` | VisiData CSV/TSV TUI (Tokyo Night Storm theme) |

## What mise Installs

Defined in `mise/.config/mise/config.toml` (work) and
`mise-omarc/.config/mise/config.toml` (personal). Tools already provided by
the system (pacman/omarchy) -- `neovim`, `tmux`, `herdr`, `lazygit`, `gum`,
`ripgrep`, `zoxide`, `jq`, `fzf`, `usage`, `tree-sitter-cli` -- are commented
out in both files rather than removed, so mise doesn't reinstall them.
`mise-omarc` additionally tracks `claude` and `codex`, which omarchy installs
globally via its own AI-tool wrappers.

| Category | Tools |
|----------|-------|
| **Languages** | node, go, rust |
| **Dev Tools** | harper-ls |
| **AI (personal only)** | claude, codex |

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
[obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) (the
actively-maintained `obsidian-nvim` fork) for wiki-links, daily notes,
backlinks, and note search, isolated from `nvim` so it can stay lean and
prose-tuned. Launched via `NVIM_APPNAME=nvim-notes`.

```bash
nvn            # opens with the notes workspace; forwards any nvim args otherwise
```

Notes live in two separate, git-tracked vault repos — not part of this
dotfiles repo on purpose (personal notes shouldn't end up on a work
machine that also uses these dotfiles):

- **personal** → [`mkhabelaj/vault`](https://github.com/mkhabelaj/vault), cloned at `~/vault`
- **work** → [`mkhabelaj/work-vault`](https://github.com/mkhabelaj/work-vault), cloned at `~/work-vault`

Each is a flat `notes/` pool (organize via backlinks/tags/MOC notes, not
topic folders) + a `daily/` log + `templates/`, with its own README
documenting the philosophy in full. `<leader>nw` switches which vault is
active; a vault not cloned on a given machine is just skipped, no error.

**From the Omarchy menu:** Personal > Notes runs `nvn-today`, which opens `nvn`
straight onto today's daily note (`:Obsidian today`), or focuses the window if
it's already open. The script sets `NVIM_APPNAME` itself because `uwsm-app`
(used by Omarchy's launchers) drops the caller's environment, so a
`NVIM_APPNAME=... omarchy-launch-editor` prefix never reaches nvim. Bare `nvn`
in a terminal still opens the dashboard.

Requires `ripgrep` (for search/completion). First launch clones plugins via
`vim.pack` (**must be run interactively** — the install confirmation prompt
can't be answered headlessly); run `:Themify install` once for colorschemes.
Grammar-checks prose with `harper-ls` (installed by mise).

**Notes** (leader = `Space`): `nn`/`nN` new note / from template · `nt`
today's daily note · `n]`/`n[` tomorrow's/yesterday's daily note · `nf`
find/switch note · `ns` search notes · `n#` browse by tag · `nb` backlinks
· `nl` follow link · `nT` insert template into current note · `nw` switch
vault (personal/work) · `no` open in the Obsidian app · `nv` table of
contents · `nr` rename note (updates references) · `np` paste image from
clipboard · `nc` toggle checkbox (normal + visual).

**Visual mode**: `nk` link selection to an existing note (the "create a
backlink" flow) · `nK` link selection to a new note · `nx` extract
selection into its own new note.

**Search**: `sb` fuzzy-search the current buffer's lines · `st` open todos —
a picker of every unchecked `- [ ]` with real content across the active vault
(bare `- [ ]` template scaffold lines are excluded).

**Code/LSP** (`harper-ls` grammar/spell checking): `ca` code action (apply
a suggestion) · `cd` show diagnostic detail.

**Completions** (blink.cmp): wiki-links `[[`, `#tags`, and `[^footnotes` come
from obsidian-ls; a small contextual source adds callout types after `> [!`
(→ `> [!note]`) and date expansions (`/today`/`/tomorrow`/`/yesterday`/`/now`
→ the resolved date). Markdown snippets (`mermaid`, `math`, `fm`, `hr`,
`cfold`, `table`, `code`, `task`, …) live in `snippets/markdown.lua`.

**Other**: `zz`/`zZ` zen mode · `us`/`uw`/`uc` toggle spell/wrap/word-count ·
floating `:` cmdline (noice).

## Hyprland (`hypr`)

Omarchy's own defaults live in `/usr/share/omarchy/default/hypr/`; the files
in `~/.config/hypr` are the user-override layer that loads after them, so
package updates don't rewrite them. This package tracks that layer:
`hyprland.lua`, `bindings.lua`, `input.lua`, `looknfeel.lua`, `autostart.lua`,
`hyprsunset.conf`, `xdph.conf`, `.luarc.json`.

`monitors.lua` is **gitignored**. Omarchy rewrites it in place
(`omarchy-hyprland-monitor-scaling` edits the scale values) and its contents
are specific to this machine's display. The file stays on disk in the package
directory, but isn't committed.

On a fresh omarchy install, `~/.config/hypr` already exists (from the
installer's skeleton), so move it aside before stowing, then restore or
recreate `monitors.lua`, since `hyprland.lua` requires it:

```bash
mv ~/.config/hypr ~/.config/hypr.orig
stow hypr
cp ~/.config/hypr.orig/monitors.lua ~/.config/hypr/
```

Omarchy can still edit these files through the symlink (a migration during
`omarchy-update`, or `omarchy-refresh-hyprland`, which overwrites them with
the shipped defaults). Run `git status` in this repo after an update to spot
any change.

## Herdr learn menu (`herdr` + `omarchy`)

Omarchy's **Learn > Herdr** menu (and `SUPER+CTRL+K`) is replaced by
`herdr/.config/herdr/herdr-learn.py`: a searchable list of every herdr key with a
one-line description, so you can find a key by what it does ("sidebar",
"rename", "side by side") instead of by name. It also lists the custom
`CTRL+H/J/K/L` pane-nav keys and shows the tmux equivalent where there is one.

- The action list and default keys come from `herdr --default-config`, then
  `config.toml` overrides them, so it follows herdr updates on its own.
- Descriptions, groups and tmux hints live in `herdr-learn.toml`. An action with
  no entry is still listed, just without a description. After updating herdr,
  run `herdr-learn.py --check` to see what needs one; `--print` dumps the rows.
- Needs `python3` >= 3.11 (for `tomllib`).
- The `omarchy` package tracks **only**
  `~/.config/omarchy/extensions/omarchy-menu.jsonc`, which points the Learn >
  Herdr row at this script. The rest of `~/.config/omarchy` (themes, hooks,
  branding, `shell.toml`) is Omarchy-managed and deliberately not tracked.
- `SUPER+CTRL+K` is rebound in the `hypr` package's `bindings.lua`.

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
├── hypr/.config/hypr/       # → ~/.config/hypr/ (omarchy only)
├── omarchy/.config/omarchy/extensions/  # → ~/.config/omarchy/extensions/ (omarchy only, one file)
├── fish/.config/fish/       # → ~/.config/fish/
├── mise/.config/mise/       # → ~/.config/mise/ (work)
├── mise-omarc/.config/mise/ # → ~/.config/mise/ (personal)
└── flo/.config/flo/         # → ~/.config/flo/
```
