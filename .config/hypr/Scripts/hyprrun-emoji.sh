#!/usr/bin/env zsh

FZF_EMOJI_DATA_FILE="$HOME/.config/hypr/Scripts/emoji.json"

cat "${FZF_EMOJI_DATA_FILE}" \
  | jq -r '.[] | (.emoji + " :" + .aliases[0] + ": "+ .category + " » " + .description)' \
  | fzf \
    --delimiter " " \
    --bind 'enter:become(printf {1} | wl-copy --trim-newline)' \
    --bind 'ctrl-c:become(printf {2} | wl-copy --trim-newline)'
