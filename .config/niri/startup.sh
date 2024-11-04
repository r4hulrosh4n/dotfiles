#!/bin/sh
gsettings set org.gnome.desktop.interface icon-theme "Colloid-dark"
gsettings set org.gnome.desktop.interface cursor-theme "phinger-cursors-light"
gsettings set org.gnome.desktop.interface gtk-theme "Colloid-Dark"
wlr-randr --output HDMI-A-1 --mode 1920x1080
