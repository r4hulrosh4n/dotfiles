#!/bin/bash

# Check the status of warp-cli
status=$(warp-cli status | grep "Connected")

if [[ -z $status ]]; then
    # If not connected, connect
    echo "Connecting to Warp..."
    warp-cli connect
else
    # If connected, disconnect
    echo "Disconnecting from Warp..."
    warp-cli disconnect
fi

