#!/bin/bash

# Function to get battery percentage
get_battery() {
    upower -i $(upower -e | grep BAT) | grep "percentage" | awk '{print $2}' || echo "N/A"
}

# Function to get system temperature
get_temperature() {
    sensors | grep -E "Package.*:" | awk '{print $4}' || echo "N/A"
}

# Function to check RAM usage
get_ram() {
    free -h | awk '/^Mem:/ {printf "%.2f / %.2f GB", $3, $2}'
}

# Function to get CPU usage
get_cpu() {
    top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}'
}

# Function to get fan speed
get_fan_speed() {
    sensors | grep -i "fan" | awk '{print $2}' || echo "N/A"
}

# Function to check if wl-screenrec is recording
is_recording() {
    pgrep -f "wl-screenrec" > /dev/null
    return $?
}

# Function to get the current power profile
get_current_profile() {
    powerprofilesctl get
}

# Function to get system uptime
get_uptime() {
    uptime -p | sed -e 's/^up //g' -e 's/and/and /g' -e 's/\([0-9]\{1,\}\) hour/\1h/g' -e 's/\([0-9]\{1,\}\) minute/\1m/g' -e 's/\([0-9]\{1,\}\) second/\1s/g' || echo "N/A"
}

# Function to get storage usage
get_storage() {
    df -h --output=target,pcent | grep '/$' | awk '{print $2}' || echo "N/A"
}

# Function to get system information manually (without Neofetch)
get_system_info() {
    echo -e "󰀓 User: rahul\n󰌢 Host: goop\n󰖲 DE: $(echo $XDG_CURRENT_DESKTOP)\n󰣇 OS: $(cat /etc/os-release | grep ^PRETTY_NAME | cut -d= -f2- | xargs)\n󰌽 Kernel: $(uname -r)\n󰻠 CPU: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)\n󰜪 GPU: $(lspci | grep VGA | awk -F: '{print $2}' | xargs)\n󰍛 Memory: $(get_ram)\n󰑹 Storage: $(get_storage)\n󰨊 Shell: $(basename $SHELL)\n󰏗 Total Packages: $(pacman -Qq | wc -l)\n󱙝 Terminal: Ghostty!"
}

# Collect system information with Material Design icons
apps="󱓟 Apps"  # App Launcher Icon
emoji=" Emoji"  # Emoji Icon
network="󰤟 Network"  # Network Icon
warp="󰅣 Warp"  # Warp Icon
bluetooth="󰂰 Bluetooth"  # Bluetooth Icon
volume="󰕾 Volume"  # Volume Icon
brightness="󰛨 Brightness"  # Brightness Icon
record=$(if is_recording; then echo "󰻃 Stop Rec"; else echo "󰻃 Record"; fi)  # Record Icon (Switch to Stop Rec if recording)
sys_stats="󰄨 Sys-Stats"  # Sys-Stats Icon
profile_options="󱐋 Profile"  # Profile Options Icon
power_options="󰐥 Power"  # Power Options Icon
info="󰋽 info"  # Info Icon

# Display system information in Fuzzel and capture selection
selection=$(echo -e "$apps\n$emoji\n$network\n$warp\n$bluetooth\n$record\n$sys_stats\n$info\n$profile_options\n$power_options" | fuzzel --dmenu --prompt "Goop:")

# Handle actions based on selection
case "$selection" in
    "󱓟 Apps")
        # Run normal fuzzel when "Apps" is selected
        fuzzel
        ;;
    " Emoji")
        # Run the bemoji program when "Emoji" is selected
        bemoji
        ;;
    "󰤟 Network")
        # Run network.sh when "Network" is selected
        ~/.config/fuzzel/network.sh
        ;;
    "󰅣 Warp")
        # Show options for Warp (Connect / Disconnect)
        warp_action=$(echo -e "󱋌 Connect\n󰅤 Disconnect" | fuzzel --dmenu --prompt "Warp:")
        case "$warp_action" in
            "󱋌 Connect") warp-cli connect ;;
            "󰅤 Disconnect") warp-cli disconnect ;;
        esac
        ;;
    "󰂰 Bluetooth")
        # Run bluetooth.sh when "Bluetooth" is selected
        ~/.config/fuzzel/bluetooth.sh
        ;;
    "󰻃 Record"|"󰻃 Stop Rec")
        # Toggle screen recording
        ~/.config/niri/screenrec.sh
        ;;
    "󰄨 Sys-Stats")
        # Show system stats when "Sys-Stats" is selected
        stats_info=$(echo -e "󰘚 RAM: $(get_ram)\n󰍛 CPU: $(get_cpu)\n󱊢 BAT: $(get_battery)\n󱃃 TEMP: $(get_temperature)\n󰈐 FAN: $(get_fan_speed)\n󰪠 Uptime: $(get_uptime)")
        echo -e "$stats_info" | fuzzel --dmenu --prompt "Sys-Stats:"
        ;;
    "󰋽 info")
        # Show system info without using Neofetch
        system_info=$(get_system_info)
        echo -e "$system_info" | fuzzel --dmenu --prompt "Info:"
        ;;
    "󱐋 Profile")
        # Power profile options (Performance, Balanced, Power Saver)
        current_profile=$(get_current_profile)
        profile_action=$(echo -e "󱐋 Performance$(if [ "$current_profile" = "performance" ]; then echo " - active"; fi)\n󱓝 Balanced$(if [ "$current_profile" = "balanced" ]; then echo " - active"; fi)\n󰌪 Power Saver$(if [ "$current_profile" = "power-saver" ]; then echo " - active"; fi)" | fuzzel --dmenu --prompt "Profile:")
        case "$profile_action" in
            "󱐋 Performance")
                powerprofilesctl set performance
                ;;
            "󱓝 Balanced")
                powerprofilesctl set balanced
                ;;
            "󰌪 Power Saver")
                powerprofilesctl set power-saver
                ;;
        esac
        ;;
    "󰐥 Power")
        # Power options (Shutdown, Restart, Sleep)
        power_action=$(echo -e "󰐥 Shutdown\n󰜉 Restart\n󰤄 Sleep" | fuzzel --dmenu --prompt "Power:")
        case "$power_action" in
            "󰐥 Shutdown")
                shutdown now
                ;;
            "󰜉 Restart")
                reboot
                ;;
            "󰤄 Sleep")
                systemctl suspend
                ;;
        esac
        ;;
    *)
        echo "Option not found!"
        ;;
esac

