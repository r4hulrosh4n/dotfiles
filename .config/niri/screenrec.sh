#!/bin/bash

# Create the directory if it doesn't exist
mkdir -p ~/Videos/recording

# Generate a filename with the date and time
FILENAME=~/Videos/recording/$(date '+%Y-%m-%d_%H-%M-%S').mp4

# Check if wl-screenrec is already running
if pgrep -x "wl-screenrec" > /dev/null; then
    # Stop the recording if it's running
    pkill wl-screenrec
else
    # Start recording with wl-screenrec
    # wl-screenrec --output=eDP-1 --audio --audio-device bluez_output.98_47_44_15_6B_4F.1.monitor -f "$FILENAME" &
    wl-screenrec --output=eDP-1 --audio --audio-device bluez_input.98_47_44_15_6B_4F -f "$FILENAME" &
fi

