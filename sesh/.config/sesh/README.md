# Sesh Configuration

Multi-environment sesh configuration using modular TOML files and GNU stow.

## Structure

```
.config/sesh/
├── .gitignore              # Ignores sesh.toml (machine-specific)
├── README.md               # This file
├── configs/
│   ├── common.toml        # Universal sessions (all platforms)
│   ├── macos.toml         # macOS-only sessions
│   ├── ubuntu.toml        # Ubuntu/Linux-only sessions
│   └── work.toml          # Work-specific sessions
└── examples/
    ├── sesh.macos.toml           # Example for macOS
    ├── sesh.ubuntu.toml          # Example for Ubuntu
    ├── sesh.work-macos.toml      # Example for work macOS
    └── sesh.work-ubuntu.toml     # Example for work Ubuntu
```

## Setup

### 1. Stow the sesh configuration

```bash
cd ~/dotfiles
stow sesh
```

### 2. Choose and copy the appropriate example

**For personal macOS:**
```bash
cd ~/.config/sesh
cp examples/sesh.macos.toml sesh.toml
```

**For personal Ubuntu/Linux:**
```bash
cd ~/.config/sesh
cp examples/sesh.ubuntu.toml sesh.toml
```

**For work macOS:**
```bash
cd ~/.config/sesh
cp examples/sesh.work-macos.toml sesh.toml
```

**For work Ubuntu/Linux:**
```bash
cd ~/.config/sesh
cp examples/sesh.work-ubuntu.toml sesh.toml
```

### 3. Test your configuration

```bash
sesh list -c
```

## How It Works

### Modular Configuration

Each environment type has its own config file:

- **common.toml** - Sessions that work everywhere (dotfiles, configs, etc.)
- **macos.toml** - macOS-specific sessions (Homebrew, Applications, etc.)
- **ubuntu.toml** - Linux-specific sessions (apt, systemd, docker, etc.)
- **work.toml** - Work-specific sessions (customize for your projects)

### Import System

The main `sesh.toml` file (machine-specific, not committed) imports the relevant configs:

```toml
# Example: sesh.macos.toml
import = [
  "~/.config/sesh/configs/common.toml",
  "~/.config/sesh/configs/macos.toml",
]
```

This means you only see sessions relevant to your current platform!

### No Conflicts

Each platform file uses distinct session names:
- macOS: "brew 🍺", "macOS Downloads", "Applications"
- Ubuntu: "apt 📦", "Linux Downloads", "systemd services"

So you can safely commit all config files without conflicts.

## Customization

### Add Personal Sessions

Edit your local `sesh.toml` (not committed to git):

```toml
import = [
  "~/.config/sesh/configs/common.toml",
  "~/.config/sesh/configs/macos.toml",
]

# Add personal sessions here
[[session]]
name = "secret-project"
path = "~/projects/secret"
startup_command = "nvim"
```

### Modify Shared Configs

Edit the config files in `configs/` directory:
- Changes to `common.toml` affect all machines
- Changes to `macos.toml` affect only macOS machines
- Changes to `ubuntu.toml` affect only Ubuntu machines
- Changes to `work.toml` affect only work machines

These files ARE committed to git, so changes sync across machines.

### Add Work Projects

Edit `configs/work.toml` and uncomment/customize the example sessions:

```toml
[[session]]
name = "work-frontend 🎨"
path = "~/work/frontend"
startup_command = "nvim"
```

Then use the work example files:
- `examples/sesh.work-macos.toml` on work Mac
- `examples/sesh.work-ubuntu.toml` on work Linux

## Tips

### Avoid Sensitive Info

The `configs/` directory is committed to git. Don't include:
- API keys or passwords
- Proprietary project names
- Company-specific paths

Instead, add sensitive sessions to your local `sesh.toml`.

### Use Emojis

Add emojis to session names for quick visual identification:
- 🔧 dotfiles
- 🍺 homebrew
- 📦 packages
- 🐳 docker
- 💼 work projects

### Preview Commands

Use preview commands to show useful info:

```toml
preview_command = "eza --all --git --icons --color=always {}"
preview_command = "bat --color=always {}/README.md"
preview_command = "docker ps -a"
```

### Multiple Windows

Define reusable window layouts:

```toml
[[session]]
name = "project"
path = "~/project"
windows = ["git", "logs"]

[[window]]
name = "git"
startup_script = "lazygit"

[[window]]
name = "logs"
startup_script = "tail -f logs/app.log"
```

## Troubleshooting

### "couldn't read import file"

This means a referenced import file doesn't exist. Make sure:
1. You copied an example file to `sesh.toml`
2. The `configs/` directory exists
3. All imported files are present

### Sessions not showing up

Check which configs are loaded:
```bash
cat ~/.config/sesh/sesh.toml
```

Verify imports point to the right files.

### Duplicate sessions

If you see duplicate session names, check:
1. No duplicate names in different config files
2. Your local `sesh.toml` doesn't duplicate configs

## References

- [Sesh GitHub](https://github.com/joshmedeski/sesh)
- [Sesh Documentation](https://github.com/joshmedeski/sesh#readme)
- [GNU Stow](https://www.gnu.org/software/stow/)
