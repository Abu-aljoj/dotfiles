#!/bin/sh

# Set the directory containing your wallpapers
WALLPAPER_DIR="$HOME/Pictures/JaKooLit-Wallpepers/"

# Find all .png, .jpg, and .jpeg files in the directory
RANDOM_IMAGE=$(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

# Update the Hyprlock configuration to use the random image
sed -i "s|path = .*|path = $RANDOM_IMAGE|" "$HOME/.config/hypr/hyprlock.conf"

# Optionally, you can also set additional background parameters here if needed
