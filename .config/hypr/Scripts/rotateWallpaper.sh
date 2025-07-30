#!/usr/bin/env zsh

# https://github.com/flkcgn/hyprpaper_wallpaper_rotator {edited}

# Configuration
WALLPAPER_DIR="${HOME}/Pictures/Wallpapers/Nord-Wallpaper"
CONFIG_FILE="${HOME}/.config/hypr/hyprpaper.conf"
HYPLOCK_CONF="${HOME}/.config/hypr/hyprlock.conf"
MONITOR=" "

# Function to change wallpaper
change_wallpaper() {
  # Find all wallpaper files safely (handling spaces)
  local wallpapers=()
  while IFS= read -r -d $'\0' file; do
    wallpapers+=("$file")
  done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0)

  # Exit if no wallpapers found
  if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in directory: $WALLPAPER_DIR"
    exit 1
  fi

  # Select random wallpaper
  local random_index=$((RANDOM % ${#wallpapers[@]}))
  local selected_wallpaper="${wallpapers[$random_index]}"
  echo "Selected wallpaper: $selected_wallpaper"

  # Kill existing hyprpaper instances
  pkill hyprpaper || true

  # Ensure config file exists and is writable
  if ! touch "$CONFIG_FILE" 2>/dev/null; then
    echo "No write permission for $CONFIG_FILE. Creating temporary config..."
    CONFIG_FILE="$(mktemp /tmp/hyprpaper_temp.XXXXXX.conf)"
  fi

  # Write new hyprpaper configuration
  cat >"$CONFIG_FILE" <<EOF
preload = $selected_wallpaper
wallpaper = $MONITOR,$selected_wallpaper
ipc = true
EOF

  echo "Configuration written to: $CONFIG_FILE"

  # Update hyprlock.conf background path
  if [ -w "$HYPLOCK_CONF" ]; then
    # Replace 'path = ...' inside the background block
    sed -i "/^[[:space:]]*background[[:space:]]*{/,/^[[:space:]]*}/s|^\([[:space:]]*path[[:space:]]*= *\).*|\1$selected_wallpaper|" "$HYPLOCK_CONF"
    echo "Updated hyprlock.conf background path to: $selected_wallpaper"
  else
    echo "Warning: Cannot write to $HYPLOCK_CONF"
  fi

  # Start hyprpaper
  hyprpaper -c "$CONFIG_FILE" &
  local pid=$!

  # Verify hyprpaper started
  sleep 1
  if ! kill -0 $pid 2>/dev/null; then
    echo "Error: Failed to start hyprpaper!"
    exit 1
  fi
}

# Check dependencies
if ! command -v hyprpaper &>/dev/null; then
  echo "Error: hyprpaper is not installed!"
  exit 1
fi

# Validate wallpaper directory
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Wallpaper directory does not exist: $WALLPAPER_DIR"
  exit 1
fi

# Main execution
if [ "${1}" = "once" ]; then
  change_wallpaper
else
  echo "Starting wallpaper rotation every 10 minutes..."
  trap 'echo "Exiting..."; pkill hyprpaper; exit 0' SIGINT SIGTERM
  while true; do
    change_wallpaper
    echo "Next wallpaper change in 10 minutes..."
    sleep 600 # 10 minutes
  done
fi
