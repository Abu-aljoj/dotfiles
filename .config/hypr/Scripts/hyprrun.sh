#!/bin/zsh

apps=(
  "Bluetooth Manager:blueman-manager"
  "Btop++:kitty -e btop"
  "CMake GUI:cmake-gui"
  "Xournal++:xournalpp"
  "CUPS:~/.config/hypr/Scripts/cups.sh"
  "GIMP:gimp"
  "Kitty:kitty"
  "Kvantum Manager:kvantummanager"
  "Mirage:mirage"
  "MPV:mpv"
  "NAPS2:naps2"
  "Nemo:nemo"
  "Neovim:kittty -e nvim"
  "GTK Settings:nwg-look"
  "Passwords and Keys:seahorse"
  "Volume Control:pavucontrol"
  "Qt6 Configuration Tool:qt6ct"
  "TLPUI:tlpui"
  "Virtual Machine Manager:virt-manager"
  "Zen-browser:zen-browser"
  "Zen-browser Private Window:zen-browser --private-window"
)

choice=$(printf "%s\n" "${apps[@]}" | cut -d: -f1 | fzf --prompt="App: ")

if [ -n "$choice" ]; then
  cmd=$(printf "%s\n" "${apps[@]}" | grep "^$choice:" | cut -d: -f2)

  # Executes the app, fully detaching it from the terminal
  setsid sh -c "$cmd >/dev/null 2>&1 &"

fi
