#!/usr/bin/env zsh
set -euo pipefail

# Use a default icon if $notif is not set in environment
notif_icon=${notif:-"dialog-information"}

LAYOUT=$(hyprctl -j getoption general:layout | jq -r '.str')

case $LAYOUT in
  master)
    hyprctl keyword general:layout dwindle
    notify-send -e -u low -i "$notif_icon" "Dwindle Layout"
    ;;
  dwindle)
    hyprctl keyword general:layout master
    notify-send -e -u low -i "$notif_icon" "Master Layout"
    ;;
  *)
    notify-send -e -u low -i "$notif_icon" "Layout not recognized: $LAYOUT"
    ;;
esac
