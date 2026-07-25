#source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
~/.local/bin/mise activate fish | source
set -gx TMUX_CONFIG ~/.config/tmux/tmux.conf
alias s='sesh connect (sesh list -i | gum filter --limit 1 --placeholder "Pick a sesh" --prompt="⚡")'
alias sg='sesh connect (sesh list -i | gum filter --limit 1 --placeholder "Pick a sesh" --prompt="⚡")'

# Git checkout
abbr -a gco git checkout

# Common additions
abbr -a g git 
abbr -a ga git add
abbr -a gc git commit
abbr -a gst git status
abbr -a gpl git pull
abbr -a gps git push

abbr -a md mkdir -p

# Standalone PR-review nvim instance (nvim-octo).
# No args -> basic config; args are forwarded to nvim (files, +cmd, etc).
function nvo --description 'PR-review nvim (nvim-octo appname)'
    env NVIM_APPNAME=nvim-octo nvim $argv
end

# Standalone writing/notes nvim instance (nvim-notes).
# No args -> basic config; args are forwarded to nvim (files, +cmd, etc).
function nvn --description 'Writing/notes nvim (nvim-notes appname)'
    env NVIM_APPNAME=nvim-notes nvim $argv
end

# fzf key bindings: CTRL-R fuzzy history, CTRL-T files, ALT-C cd
if type -q fzf
    fzf --fish | source
    # Use terminal's ANSI palette so fzf tracks the active theme (Nord here)
    set -gx FZF_DEFAULT_OPTS '--color=16'
    # CTRL-R: show only the command, hide the timestamp column (alt-t toggles it back)
    set -gx FZF_CTRL_R_OPTS '--with-nth=3.. --nth=3..'
end

