#!/bin/bash

# Check if Spotify is running
if ! pgrep -x "spotify" > /dev/null; then
    spotify --ozone-platform=wayland &
    exit 0
fi

# Determine whether Spotify is playing or paused
status=$(playerctl --player=spotify status 2>/dev/null)

# Icons
next_icon="󰼧"
pause_icon="󰏤"
play_icon="󰼛"
previous_icon="󰼨"

# Set options based on Spotify status
if [[ "$status" == "Playing" ]]; then
    options="${next_icon} Next\n${pause_icon} Pause\n${previous_icon} Previous"
else
    options="${next_icon} Next\n${play_icon} Play\n${previous_icon} Previous"
fi

# Show the prompt and get the user's choice
choice=$(echo -e "$options" | fuzzel --dmenu --prompt "Spotify:")

case "$choice" in
    "${next_icon} Next")
        playerctl --player=spotify next
        ;;
    "${pause_icon} Pause")
        playerctl --player=spotify pause
        ;;
    "${play_icon} Play")
        playerctl --player=spotify play
        ;;
    "${previous_icon} Previous")
        playerctl --player=spotify previous
        ;;
    *)
        exit 0
        ;;
esac

