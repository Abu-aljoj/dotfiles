#!/usr/bin/env zsh

WORKSPACE_FILE="$HOME/.config/hypr/Configs/Workspaces.conf"
INTERNAL="eDP-1"
EXTERNAL=""

# Get connected monitors
CONNECTED=($(hyprctl monitors -j | jq -r '.[].name'))

# Find first external monitor (non-INTERNAL)
for mon in "${CONNECTED[@]}"; do
  if [[ "$mon" != "$INTERNAL" ]]; then
    EXTERNAL="$mon"
    break
  fi
done


# Write header comment after wipe
echo "### Auto-generated Workspace Assignments ###" > "$WORKSPACE_FILE"
echo "" >> "$WORKSPACE_FILE"

if [[ -z "$EXTERNAL" ]]; then
  # Only internal monitor connected: assign 1-5 to eDP-1
  for i in {1..5}; do
    echo "workspace = $i, monitor:$INTERNAL" >> "$WORKSPACE_FILE"
  done
else
  # External monitor connected
  # Odd workspaces to internal
  for i in 1 3 5 7 9; do
    echo "workspace = $i, monitor:$INTERNAL" >> "$WORKSPACE_FILE"
  done
  # Even workspaces to external
  for i in 2 4 6 8 10; do
    echo "workspace = $i, monitor:$EXTERNAL" >> "$WORKSPACE_FILE"
  done
fi
