#!/usr/bin/env bash

psswdrasi=$HOME/.config/rofi/openvpn/passwd.rasi
menurasi=$HOME/.config/rofi/openvpn/menu.rasi

profiles_dir="$HOME/.htb/"  # Set the directory path where your OpenVPN profiles are located

# Rofi options for actions
connect_option="Connect"
disconnect_option="Disconnect"

# Prompt the user to select an action
selected_action=$(echo -e "$connect_option\n$disconnect_option" | rofi  -config $menurasi -dmenu -p "HackTheBox VPN Menu" -mesg "VPN Menu")

if [[ $selected_action == $connect_option ]]; then
    # Get the list of OpenVPN profiles
    profiles=$(ls "$profiles_dir"/*.ovpn | xargs -n1 basename)

    if [[ -n $profiles ]]; then
        # Prompt for the OpenVPN profile
        selected_profile=$(echo "$profiles" | rofi -dmenu -p "Select OpenVPN profile:" -mesg "VPN Menu")

        if [[ -n $selected_profile ]]; then
            # Ask for the sudo password in the Rofi submenu using rofi-pass
            sudo_password=$(rofi -config $psswdrasi -dmenu -i -password -p "Enter sudo password:" -mesg "VPN Menu")

            # Validate sudo password
            echo "$sudo_password" | sudo -S ls >/dev/null 2>&1
            sudo_status=$?

            if [[ $sudo_status -eq 0 ]]; then
                # Run OpenVPN with sudo using the selected profile
                sudo openvpn --config "$profiles_dir/$selected_profile" &
                rofi -e "OpenVPN connected!"
            else
                rofi -e "Invalid sudo password!"
            fi
        fi
    else
        rofi -e "No OpenVPN profiles found!"
    fi
elif [[ $selected_action == $disconnect_option ]]; then
    # Ask for the sudo password in the Rofi submenu using rofi-pass
    sudo_password=$(rofi -config $psswdrasi -dmenu -i -password -p  "Enter sudo password:" -mesg "VPN Menu")

    # Validate sudo password
    echo "$sudo_password" | sudo -S ls >/dev/null 2>&1
    sudo_status=$?

    if [[ $sudo_status -eq 0 ]]; then
        # Get the list of running OpenVPN processes
        vpn_processes=$(pgrep openvpn)

        if [[ -n $vpn_processes ]]; then
            # Terminate the OpenVPN connection using sudo
            sudo pkill openvpn
            rofi -e "OpenVPN disconnected!"
        else
            rofi -e "No active OpenVPN connection!"
        fi
    else
        rofi -e "Invalid sudo password!"
    fi
fi
