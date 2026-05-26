#source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
~/.local/bin/mise activate fish | source
set -gx TMUX_CONFIG ~/.config/tmux/tmux.conf
