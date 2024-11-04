#!/bin/bash

# Path to the Python script
script_dir="$HOME/.config/niri/Week-Wallpaper"
python_script="$script_dir/weekly_generator.py"

# Path to the static wallpaper
static_wallpaper="$HOME/.config/niri/bg/wallpaper.png"

# PID file to track the running process
pid_file="$script_dir/script.pid"

# Function to generate a wallpaper
generate_wallpaper() {
    echo "Generating new wallpaper..."
    start_time=$(date +%s)
    python3 "$python_script" "$script_dir/wallpaper.png" "$static_wallpaper"
    if [ $? -eq 0 ]; then
        end_time=$(date +%s)
        echo "Wallpaper generation took $((end_time - start_time)) seconds."
        echo "Killing existing swaybg process..."
        pkill swaybg
        swaybg --image "$script_dir/wallpaper.png" --mode fill &
    else
        echo "Failed to generate wallpaper."
    fi
}

# Check if the script is already running
if [ -f "$pid_file" ]; then
    # Read the PID from the PID file
    running_pid=$(cat "$pid_file")

    # Check if the process is still running
    if ps -p $running_pid > /dev/null; then
        echo "Terminating existing wallpaper generation process with PID: $running_pid."
        kill "$running_pid"  # Kill the running process
        rm "$pid_file"  # Remove the PID file
        echo "Setting default wallpaper."
        pkill swaybg  # Kill any existing swaybg processes
        swaybg --image "$static_wallpaper" --mode fill &  # Set the default wallpaper
        exit 0  # Exit the script
    else
        rm "$pid_file"  # Remove stale PID file if process is not running
    fi
fi

# Write the current PID to the PID file
echo $$ > "$pid_file"

# Start wallpaper generation every week (604800 seconds)
echo "Starting wallpaper generation every week..."
while true; do
    generate_wallpaper
    sleep 604800  # Sleep for one week
done

