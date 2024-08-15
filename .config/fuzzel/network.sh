#!/usr/bin/env python3

import subprocess
import dbus
from dbus.mainloop.glib import DBusGMainLoop

DBusGMainLoop(set_as_default=True)
system = dbus.SystemBus()

def get_active_connection_uuids():
    manager = system.get_object("org.freedesktop.NetworkManager",
                                "/org/freedesktop/NetworkManager")
    manager = dbus.Interface(manager, "org.freedesktop.DBus.Properties")
    active_paths = manager.Get("org.freedesktop.NetworkManager", "ActiveConnections")
    active_connections = []

    for path in active_paths:
        active_con = system.get_object("org.freedesktop.NetworkManager", path)
        active_con = dbus.Interface(active_con, "org.freedesktop.DBus.Properties")
        con_path = active_con.Get("org.freedesktop.NetworkManager.Connection.Active", "Connection")

        con_data = system.get_object("org.freedesktop.NetworkManager", con_path)
        con_data = dbus.Interface(con_data, "org.freedesktop.NetworkManager.Settings.Connection").GetSettings()

        uuid = str(con_data["connection"]["uuid"])
        active_connections.append(uuid)

    return active_connections

def get_connections():
    active_connections = get_active_connection_uuids()

    settings = system.get_object("org.freedesktop.NetworkManager",
                                 "/org/freedesktop/NetworkManager/Settings")
    settings = dbus.Interface(settings, "org.freedesktop.NetworkManager.Settings")
    paths = settings.ListConnections()

    connections = []
    for path in paths:
        con_data = system.get_object("org.freedesktop.NetworkManager", path)
        con_data = dbus.Interface(con_data, "org.freedesktop.NetworkManager.Settings.Connection").GetSettings()

        # Filter for Wi-Fi connections only
        if str(con_data["connection"]["type"]) != "802-11-wireless":
            continue

        connections.append({
            "name": str(con_data["connection"]["id"]),
            "active": str(con_data["connection"]["uuid"]) in active_connections
        })

    return connections

def fuzzel_menu():
    connections = get_connections()
    options = []

    for conn in connections:
        state = "Connected" if conn["active"] else "Disconnected"
        options.append(f"{conn['name']} | {state}")

    fuzzel_cmd = subprocess.Popen(['fuzzel', '--dmenu', '--prompt', 'Select Wi-Fi:'], 
                                  stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    selection, _ = fuzzel_cmd.communicate(input="\n".join(options).encode())

    selected = selection.decode().strip()
    if selected:
        name, state = selected.split(" | ")
        if state == "Connected":
            subprocess.run(["nmcli", "connection", "down", name])
        else:
            subprocess.run(["nmcli", "connection", "up", name])

if __name__ == "__main__":
    fuzzel_menu()
