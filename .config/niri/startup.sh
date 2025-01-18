#!/bin/bash

# Define Themes
DARK_GTK="Colloid-Dark"
DARK_ICONS="Colloid-dark"
DARK_KITTY="Catppuccin-Mocha"
WALLPAPER_DIR="$HOME/.config/niri/bg"
DARK_WALLPAPER="wallpaper-dark.png"
WAYBAR_CONFIG="$HOME/.config/waybar/style.css"
FUZZEL_CONFIG="$HOME/.config/fuzzel/fuzzel.ini"
NIRI_CONFIG="$HOME/.config/niri/config.kdl"
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"
CATPPUCCIN_LUA="$HOME/.config/nvim/lua/plugins/catppuccin.lua"

# Define Fuzzel theme colors for Dark Mode
DARK_FUZZEL_BACKGROUND="060606FF"
DARK_FUZZEL_BORDER="ffffff1A"
DARK_FUZZEL_TEXT="f0fdff80"
DARK_FUZZEL_SELECTION_TEXT="f0fdffff"
DARK_FUZZEL_SELECTION="2d2d2dff"

# Define Focus Ring Colors for Dark Mode
DARK_FOCUS_RING_ACTIVE_COLOR="hsla(251, 100%, 100%, 0.15)"
DARK_FOCUS_RING_INACTIVE_COLOR="hsla(251, 100%, 100%, 0.0)"

# Define Dunst Colors for Dark Mode
DARK_BACKGROUND="#131313"
DARK_FOREGROUND="#f0fdff"

# Function to restart Fuzzel if it's running
restart_fuzzel_if_running() {
    if pgrep -x "fuzzel" > /dev/null; then
        killall fuzzel
        sleep 0.5  # Wait a moment before restarting
        fuzzel &
    fi
}

# Function to set Dunst theme to dark
set_dunst_theme() {
    sed -i "s/background = .*/background = \"$DARK_BACKGROUND\"/" "$DUNST_CONFIG"
    sed -i "s/foreground = .*/foreground = \"$DARK_FOREGROUND\"/" "$DUNST_CONFIG"
}

# Function to set Dark Mode
switch_to_dark_mode() {
    # GTK
    gsettings set org.gnome.desktop.interface gtk-theme "$DARK_GTK"
    gsettings set org.gnome.desktop.interface icon-theme "$DARK_ICONS"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

    # Kitty
    kitty +kitten themes --reload-in=all "$DARK_KITTY"

    # Waybar: Change color to dark
    sed -i 's/color: rgba(0, 0, 0, 0.85);/color: rgba(255, 255, 255, 0.85);/' "$WAYBAR_CONFIG"

    # Update Fuzzel theme to dark
    sed -i "s/background = .*/background = $DARK_FUZZEL_BACKGROUND/" "$FUZZEL_CONFIG"
    sed -i "s/border = .*/border = $DARK_FUZZEL_BORDER/" "$FUZZEL_CONFIG"
    sed -i "s/text = .*/text = $DARK_FUZZEL_TEXT/" "$FUZZEL_CONFIG"
    sed -i "s/selection-text = .*/selection-text = $DARK_FUZZEL_SELECTION_TEXT/" "$FUZZEL_CONFIG"
    sed -i "s/selection = .*/selection = $DARK_FUZZEL_SELECTION/" "$FUZZEL_CONFIG"

    # Update Niri focus ring colors to dark
    sed -i "s/active-color .*/active-color \"$DARK_FOCUS_RING_ACTIVE_COLOR\"/" "$NIRI_CONFIG"
    sed -i "s/inactive-color .*/inactive-color \"$DARK_FOCUS_RING_INACTIVE_COLOR\"/" "$NIRI_CONFIG"

    # Kill existing swaybg process
    killall swaybg

    # Wallpaper
    swaybg --image "$WALLPAPER_DIR/$DARK_WALLPAPER" --mode fill

    # Restart Waybar
    killall waybar && waybar &

    # Kill and relaunch dunst
    killall dunst
    dunst &

    # Restart Fuzzel if running
    restart_fuzzel_if_running

    # Set Dunst theme to dark
    set_dunst_theme

    # Change tmux theme to Mocha
    sed -i "s/@catppuccin_flavor 'mocha'/@catppuccin_flavor 'latte'/g" ~/.config/tmux/tmux.conf
    tmux source-file ~/.config/tmux/tmux.conf

    sed -i 's/vim.cmd.colorscheme("catppuccin-latte")/vim.cmd.colorscheme("catppuccin-mocha")/' "$CATPPUCCIN_LUA"

    # Reload Neovim to apply the theme (without restart)
    nvim -c "source $CATPPUCCIN_LUA" -c "autocmd VimEnter * quit"

    notify-send "Theme: Dark Mode Activated" -t 1000
}

# Execute Dark Mode setup
switch_to_dark_mode

