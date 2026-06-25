#!/usr/bin/env bash
# Seamless herdr <-> nvim pane navigation (vim-tmux-navigator style).
# herdr binds ctrl+h/j/k/l to this script. If the focused pane is running
# nvim/vim, forward the key into it so nvim handles the split move (and only
# falls back to herdr at its split edge). Otherwise move the herdr pane.
set -euo pipefail

dir="${1:?direction required: left|down|up|right}"
case "$dir" in
  left)  key="ctrl+h" ;;
  down)  key="ctrl+j" ;;
  up)    key="ctrl+k" ;;
  right) key="ctrl+l" ;;
  *) echo "bad direction: $dir" >&2; exit 1 ;;
esac

info=$(herdr pane process-info --current)
pane=$(printf '%s' "$info" | grep -oP '"pane_id":"\K[^"]+' | head -1)

if printf '%s' "$info" | grep -qiE '"name":"(n?vim|view)"'; then
  herdr pane send-keys "$pane" "$key"
else
  herdr pane focus --direction "$dir" --current
fi
