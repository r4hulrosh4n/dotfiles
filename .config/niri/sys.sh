#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

cat_ascii=$(cat <<'EOF'
  \    /\
   )  ( ')
  (  /  )
   \(__)|
EOF
)

datetime=$(date "+%b %d %H:%M")

if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
    battery=$(cat /sys/class/power_supply/BAT0/capacity)
else
    battery="N/A"
fi

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')

ram=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')

cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.1f%%", usage}')

content=$(printf "%s\n\n%s\n${BLUE}CPU:${RESET} ${RED}%s${RESET}\n${BLUE}RAM:${RESET} ${YELLOW}%s${RESET}\n${BLUE}Battery:${RESET} ${GREEN}%s%%${RESET}\n${BLUE}Volume:${RESET} ${GREEN}%s%%${RESET}" \
"$cat_ascii" \
"$datetime" \
"$cpu" \
"$ram" \
"$battery" \
"$volume")

echo -e "$content"

