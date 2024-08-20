#!/bin/bash

# Check if Spotify is running
if ! pgrep -x "spotify" > /dev/null; then
    exit 0
fi

# Get the current status (Playing, Paused, Stopped)
status=$(playerctl -p spotify status 2>/dev/null)

# Get the current song title
song=$(playerctl -p spotify metadata --format "{{ title }}" 2>/dev/null)

# Path to store the volume
volume_file="/tmp/spotify_volume"
ad_file="/tmp/spotify_ad_flag"

# Function to handle volume restoration
restore_volume() {
    if [ -f "$volume_file" ]; then
        saved_volume=$(cat "$volume_file")
        playerctl -p spotify volume "$saved_volume"
        rm "$volume_file" # Remove the volume file after restoration
        rm "$ad_file" # Remove ad flag file
    fi
}

# Detect if the title is "Advertisement"
if [ "$song" == "Advertisement" ]; then
    # Save the current volume and mute it
    if [ ! -f "$ad_file" ]; then
        current_volume=$(playerctl -p spotify volume)
        echo "$current_volume" > "$volume_file"
        touch "$ad_file" # Create ad flag file
        playerctl -p spotify volume 0
    fi
    
    # Show Advertisement text
    echo "  Advertisement"
else
    # Restore volume if an ad has ended
    if [ -f "$ad_file" ]; then
        restore_volume
    fi
    
    # Show the song title with the appropriate icon
    if [ "$status" == "Playing" ]; then
        echo "  $song" # Playing icon with song name
    elif [ "$status" == "Paused" ]; then
        echo "  $song" # Paused icon with song name
    else
        exit 0
    fi
fi

