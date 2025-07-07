#!/bin/sh

# Define the DDC/CI display number directly (your Acer monitor is 1)
MONITOR_ID=1

# Function to get current brightness and output JSON
get_brightness_json() {
    # Get the brightness value from ddcutil.
    # 2>/dev/null redirects stderr (errors/warnings) to null, silencing them.
    # grep -oP 'current value =\s*\K\d+' extracts the number:
    #   'current value =' matches the literal text.
    #   '\s*' matches any whitespace characters (spaces, tabs) zero or more times.
    #   '\K' tells grep to "keep" the match up to this point, so it only outputs what comes *after* it.
    #   '\d+' matches one or more digits (the brightness value).
    # head -n 1 ensures only the first matching line is processed, if any.
    BRIGHTNESS=$(ddcutil getvcp 10 --display "$MONITOR_ID" 2>/dev/null | grep -oP 'current value =\s*\K\d+' | head -n 1)

    # Use shell parameter expansion to default BRIGHTNESS to 0 if it's empty/not found.
    BRIGHTNESS=${BRIGHTNESS:-0}

    # Output the brightness as a JSON string for Waybar.
    echo "{\"text\": \"$BRIGHTNESS%\", \"percentage\": $BRIGHTNESS}"
}

# Check command-line arguments to determine action (up, down, or just get)
if [ "$1" = "up" ]; then # Using [ ] and = for /bin/sh compatibility
    # Increase brightness by 5%. Suppress all output from ddcutil.
    ddcutil setvcp 10 + 5 --display "$MONITOR_ID" --sleep-multiplier 0.05 &> /dev/null
    sleep 1 # Small delay to allow the change to apply
    get_brightness_json # Re-read and output the new brightness as JSON
elif [ "$1" = "down" ]; then # Using [ ] and = for /bin/sh compatibility
    # Decrease brightness by 5%. Suppress all output from ddcutil.
    ddcutil setvcp 10 - 5 --display "$MONITOR_ID" --sleep-multiplier 0.05 &> /dev/null
    sleep 1 # Small delay to allow the change to apply
    get_brightness_json # Re-read and output the new brightness as JSON
else
    # If no valid arguments, just get the current brightness and output as JSON
    get_brightness_json
fi
