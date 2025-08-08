#!/usr/bin/env zsh

# Use cliphist + fzf to pick a clipboard entry
selection=$(cliphist list | fzf --prompt="> ") || exit 0

# Decode and copy to Wayland clipboard
echo "$selection" | cliphist decode | wl-copy

# Fully detach the process and close terminal
setsid sh -c "exit" >/dev/null 2>&1 & disown
