#!/usr/bin/env zsh

STEP=5
VCP_CODE=10

# Find the first detected display
DISPLAY_ID=$(ddcutil detect | grep -m1 "Display" | awk '{print $2}')

if [[ -z "$DISPLAY_ID" ]]; then
    echo '{"text": "󰃞 --%", "tooltip": "No external display detected"}'
    exit 0
fi

# Get current and max values
raw_output=$(ddcutil getvcp $VCP_CODE --display $DISPLAY_ID 2>/dev/null)

# Parse values using grep + sed for better Zsh compatibility
current=$(echo "$raw_output" | grep "current value" | sed -E 's/.*current value = *([0-9]+),.*/\1/')
max=$(echo "$raw_output" | grep "max value" | sed -E 's/.*max value = *([0-9]+).*/\1/')

# Validate values
if [[ -z "$current" || -z "$max" || "$max" -eq 0 ]]; then
    echo '{"text": "󰃞 --%", "tooltip": "Failed to read brightness"}'
    exit 1
fi

# Optional brightness adjustment
if [[ "$1" == "up" ]]; then
    new=$((current + STEP))
    (( new > max )) && new=$max
    ddcutil setvcp $VCP_CODE $new --display $DISPLAY_ID
    current=$new
elif [[ "$1" == "down" ]]; then
    new=$((current - STEP))
    (( new < 0 )) && new=0
    ddcutil setvcp $VCP_CODE $new --display $DISPLAY_ID
    current=$new
fi

# Recalculate brightness percent
percent=$((100 * current / max))

# Choose icon based on percent
choose_icon() {
    local p=$1
    if (( p < 10 )); then echo ""
    elif (( p < 30 )); then echo ""
    elif (( p < 50 )); then echo ""
    elif (( p < 70 )); then echo "󰃝"
    elif (( p < 85 )); then echo "󰃞"
    elif (( p < 95 )); then echo "󰃟"
    else echo "󰃠"
    fi
}

icon=$(choose_icon "$percent")

echo "{\"text\": \"$icon  ${percent}%\", \"tooltip\": \"External Brightness: ${percent}%\"}"
