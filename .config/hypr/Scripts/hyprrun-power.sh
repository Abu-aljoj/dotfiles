#!/usr/bin/env zsh

choice=$(printf "%s\n" "Lock" "Sleep" "Logout" "Reboot" "Shutdown" | fzf --prompt="> ")

if [[ -z "$choice" ]]; then
  exit
fi

if [[ "$choice" == "Lock" ]]; then
  hyprlock
elif [[ "$choice" == "Sleep" ]]; then
  systemctl suspend
elif [[ "$choice" == "Logout" ]]; then
  read -q "?Are you sure you want to Logout? [y/N] " || {
    echo "\nCanceled Logout"
    exit
  }
  echo
  uwsm stop
elif [[ "$choice" == "Reboot" ]]; then
  read -q "?Are you sure you want to Reboot? [y/N] " || {
    echo "\nCanceled Reboot"
    exit
  }
  echo
  systemctl reboot
elif [[ "$choice" == "Shutdown" ]]; then
  read -q "?Are you sure you want to Shutdown? [y/N] " || {
    echo "\nCanceled Shutdown"
    exit
  }
  echo
  systemctl poweroff
fi
