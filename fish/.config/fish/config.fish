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

