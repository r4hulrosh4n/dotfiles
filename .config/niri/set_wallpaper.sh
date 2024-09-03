#!/bin/bash

# Path to the backgrounds folder
BACKGROUND_DIR="$HOME/Pictures/background"

# Function to set a new wallpaper
set_wallpaper() {
    # Kill any existing swaybg process
    pkill -x swaybg

    # Select a random image from the backgrounds directory
    WALLPAPER=$(find "$BACKGROUND_DIR" -type f | shuf -n 1)

    # Set the new wallpaper
    swaybg --image "$WALLPAPER" --mode fill &
}

# Set wallpaper immediately
set_wallpaper

# Repeat every 5 minutes (300 seconds)
while true; do
    sleep 300
    set_wallpaper
done

