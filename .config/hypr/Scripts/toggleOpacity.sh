#!/bin/sh
# Script for changing opacity on the fly

STATE=$(hyprctl -j getoption decoration:active_opacity | jq ".float")

if [ "${STATE}" == "0.900000" ]; then
  hyprctl keyword decoration:active_opacity 1
  hyprctl keyword decoration:inactive_opacity 1
  hyprctl keyword decoration:dim_inactive false
else
  hyprctl keyword decoration:active_opacity 0.9
  hyprctl keyword decoration:inactive_opacity 0.9
  hyprctl keyword decoration:dim_inactive true
fi
