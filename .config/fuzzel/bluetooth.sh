#!/bin/bash

# Get a list of Bluetooth devices with their connection status
devices=$(bluetoothctl devices | while read -r line; do
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d ' ' -f 3-)
    # Check connection status
    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        echo " $name - connected"
    else
        echo " $name"
    fi
done)

# Use fuzzel to select a device
selected_device_with_status=$(echo "$devices" | fuzzel --dmenu --prompt "Bluetooth:")

# Check if a device was selected (not empty)
if [ -n "$selected_device_with_status" ]; then
    # Extract the actual device name (remove the icon and " - connected" if present)
    selected_device=$(echo "$selected_device_with_status" | sed 's/^ //' | sed 's/ - connected//')

    # Extract MAC address based on the selected device name
    mac=$(bluetoothctl devices | grep "$selected_device" | awk '{print $2}')

    # Check if the device is already connected
    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        bluetoothctl disconnect "$mac"
    else
        bluetoothctl connect "$mac"
    fi
fi

