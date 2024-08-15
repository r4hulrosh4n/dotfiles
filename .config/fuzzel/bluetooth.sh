#!/bin/bash

# Get a list of Bluetooth devices with their names only
devices=$(bluetoothctl devices | cut -d ' ' -f 3-)

# Use fuzzel to select a device
selected_device=$(echo "$devices" | fuzzel --dmenu --prompt "Bluetooth:")

# Check if a device was selected (not empty)
if [ -n "$selected_device" ]; then
    # Extract MAC address based on the selected device name
    mac=$(bluetoothctl devices | grep "$selected_device" | awk '{print $2}')

    # Check if the device is already connected
    connected=$(bluetoothctl info "$mac" | grep "Connected: yes")

    # Toggle connection based on the current state
    if [ -n "$connected" ]; then
        bluetoothctl disconnect "$mac"
    else
        bluetoothctl connect "$mac"
    fi
fi

