#!/bin/bash

# Check if Waybar is running
if pgrep -x "waybar" > /dev/null; then
    # If running, kill Waybar
    pkill waybar
else
    # If not running, start Waybar
    waybar &
fi

