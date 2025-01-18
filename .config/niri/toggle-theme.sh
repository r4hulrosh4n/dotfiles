#!/bin/bash

# Define Themes
DARK_GTK="Colloid-Dark"
LIGHT_GTK="Colloid-Light"
DARK_ICONS="Colloid-dark"
LIGHT_ICONS="Colloid-light"
DARK_KITTY="Catppuccin-Mocha"
LIGHT_KITTY="Catppuccin-Latte"
WALLPAPER_DIR="$HOME/.config/niri/bg"
DARK_WALLPAPER="wallpaper-dark.png"
LIGHT_WALLPAPER="wallpaper-light.png"
WAYBAR_CONFIG="$HOME/.config/waybar/style.css"
FUZZEL_CONFIG="$HOME/.config/fuzzel/fuzzel.ini"
NIRI_CONFIG="$HOME/.config/niri/config.kdl"
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"
CATPPUCCIN_LUA="$HOME/.config/nvim/lua/plugins/catppuccin.lua"

# Check current theme in catppuccin.lua
CURRENT_THEME=$(grep -oP 'vim.cmd.colorscheme\("\K[^"]+' "$CATPPUCCIN_LUA")

# Define Fuzzel theme colors
DARK_FUZZEL_BACKGROUND="060606FF"
DARK_FUZZEL_BORDER="ffffff1A"
DARK_FUZZEL_TEXT="f0fdff80"
DARK_FUZZEL_SELECTION_TEXT="f0fdffff"
DARK_FUZZEL_SELECTION="2d2d2dff"

LIGHT_FUZZEL_BACKGROUND="F9F9F9FF"
LIGHT_FUZZEL_BORDER="0000001A"
LIGHT_FUZZEL_TEXT="0F020080"
LIGHT_FUZZEL_SELECTION_TEXT="0F0200FF"
LIGHT_FUZZEL_SELECTION="FFFFFF"

# Define Focus Ring Colors
DARK_FOCUS_RING_ACTIVE_COLOR="hsla(251, 100%, 100%, 0.15)"
DARK_FOCUS_RING_INACTIVE_COLOR="hsla(251, 100%, 100%, 0.0)"

LIGHT_FOCUS_RING_ACTIVE_COLOR="hsla(251, 100%, 0%, 0.05)"
LIGHT_FOCUS_RING_INACTIVE_COLOR="hsla(251, 100%, 100%, 0.0)"

# Define Dunst Colors
DARK_BACKGROUND="#131313"
DARK_FOREGROUND="#f0fdff"
LIGHT_BACKGROUND="#D4D0C7"
LIGHT_FOREGROUND="#0F0200"

# Function to restart Fuzzel if it's running
restart_fuzzel_if_running() {
    if pgrep -x "fuzzel" > /dev/null; then
        killall fuzzel
        sleep 0.5  # Wait a moment before restarting
        fuzzel &
    fi
}

# Function to set Dunst theme based on mode
set_dunst_theme() {
    if [[ "$1" == "dark" ]]; then
        # Dark Mode Dunst settings
        sed -i "s/background = .*/background = \"$DARK_BACKGROUND\"/" "$DUNST_CONFIG"
        sed -i "s/foreground = .*/foreground = \"$DARK_FOREGROUND\"/" "$DUNST_CONFIG"
    else
        # Light Mode Dunst settings
        sed -i "s/background = .*/background = \"$LIGHT_BACKGROUND\"/" "$DUNST_CONFIG"
        sed -i "s/foreground = .*/foreground = \"$LIGHT_FOREGROUND\"/" "$DUNST_CONFIG"
    fi
}

# Function to switch to Light Mode
switch_to_light_mode() {
    # GTK
    gsettings set org.gnome.desktop.interface gtk-theme "$LIGHT_GTK"
    gsettings set org.gnome.desktop.interface icon-theme "$LIGHT_ICONS"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"

    # Qt
    export QT_QPA_PLATFORMTHEME="gtk2"
    export QT_STYLE_OVERRIDE="light"
    echo "export QT_QPA_PLATFORMTHEME=gtk2" >> ~/.profile
    echo "export QT_STYLE_OVERRIDE=light" >> ~/.profile

    # Kitty
    kitty +kitten themes --reload-in=all "$LIGHT_KITTY"

    # Waybar: Change color to light
    sed -i 's/color: rgba(255, 255, 255, 0.85);/color: rgba(0, 0, 0, 0.85);/' "$WAYBAR_CONFIG"

    # Update Fuzzel theme to light
    sed -i "s/background = .*/background = $LIGHT_FUZZEL_BACKGROUND/" "$FUZZEL_CONFIG"
    sed -i "s/border = .*/border = $LIGHT_FUZZEL_BORDER/" "$FUZZEL_CONFIG"
    sed -i "s/text = .*/text = $LIGHT_FUZZEL_TEXT/" "$FUZZEL_CONFIG"
    sed -i "s/selection-text = .*/selection-text = $LIGHT_FUZZEL_SELECTION_TEXT/" "$FUZZEL_CONFIG"
    sed -i "s/selection = .*/selection = $LIGHT_FUZZEL_SELECTION/" "$FUZZEL_CONFIG"

    # Update Niri focus ring colors to light
    sed -i "s/active-color .*/active-color \"$LIGHT_FOCUS_RING_ACTIVE_COLOR\"/" "$NIRI_CONFIG"
    sed -i "s/inactive-color .*/inactive-color \"$LIGHT_FOCUS_RING_INACTIVE_COLOR\"/" "$NIRI_CONFIG"

    # Kill existing swaybg process
    killall swaybg

    # Wallpaper
    swaybg --image "$WALLPAPER_DIR/$LIGHT_WALLPAPER" --mode fill

    # Restart Waybar
    killall waybar && waybar &

    # Kill and relaunch dunst
    killall dunst
    dunst &

    # Restart Fuzzel if running
    restart_fuzzel_if_running

    # Set Dunst theme to light
    set_dunst_theme "light"


    sed -i "s/@catppuccin_flavor 'latte'/@catppuccin_flavor 'mocha'/g" ~/.config/tmux/tmux.conf
    tmux source-file ~/.config/tmux/tmux.conf


    sed -i 's/vim.cmd.colorscheme("catppuccin-latte")/vim.cmd.colorscheme("catppuccin-mocha")/' "$CATPPUCCIN_LUA"


    # Reload Neovim to apply the theme (without restart)
    nvim -c "source $CATPPUCCIN_LUA" -c "autocmd VimEnter * quit"

    notify-send "Theme: Light Mode Activated" -t 1000
}

# Function to switch to Dark Mode
switch_to_dark_mode() {
    # GTK
    gsettings set org.gnome.desktop.interface gtk-theme "$DARK_GTK"
    gsettings set org.gnome.desktop.interface icon-theme "$DARK_ICONS"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

    # Qt
    export QT_QPA_PLATFORMTHEME="gtk2"
    export QT_STYLE_OVERRIDE="dark"
    echo "export QT_QPA_PLATFORMTHEME=gtk2" >> ~/.profile
    echo "export QT_STYLE_OVERRIDE=dark" >> ~/.profile

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
    set_dunst_theme "dark"

    # Change tmux theme to Mocha
    sed -i "s/@catppuccin_flavor 'mocha'/@catppuccin_flavor 'latte'/g" ~/.config/tmux/tmux.conf
    tmux source-file ~/.config/tmux/tmux.conf

    sed -i 's/vim.cmd.colorscheme("catppuccin-mocha")/vim.cmd.colorscheme("catppuccin-latte")/' "$CATPPUCCIN_LUA"

    # Reload Neovim to apply the theme (without restart)
    nvim -c "source $CATPPUCCIN_LUA" -c "autocmd VimEnter * quit"
    # Switch Kitty theme to Mocha if it is set to Latte

    notify-send "Theme: Dark Mode Activated" -t 1000
}

# Get current GTK theme
CURRENT_GTK=$(gsettings get org.gnome.desktop.interface gtk-theme)

# Switch theme based on the current GTK theme
if [[ "$CURRENT_GTK" == "'$DARK_GTK'" ]]; then
    switch_to_light_mode
else
    switch_to_dark_mode
fi

