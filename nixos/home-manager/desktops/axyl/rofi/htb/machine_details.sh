#!/usr/bin/env bash

export  appkey=$(secret-tool lookup htb-api user-htb-api)

## rasi path
rhtb=$HOME/.config/rofi/htb/

# normal dofi config for diplay
active_mac=$rhtb/rasi/active_mac.rasi
# rofi config for reset prompt
reset_prompt=$rhtb/rasi/reset_prompt.rasi
# normal rofi menu w
rofidmenu=$rhtb/rasi/dmenu.rasi


# Function to fetch machine details from Hack The Box API and display in Rofi
function show_machine_details() {
  local machine_id=$1

  # Fetch machine details from Hack The Box API
  machine_response=$(curl -s -H "Authorization: Bearer $appkey" "https://www.hackthebox.com/api/v4/machine/profile/$machine_id")
  name=$(echo "$machine_response" | jq -r '.info.name')
  ip=$(echo "$machine_response" | jq -r '.info.ip')
  points=$(echo "$machine_response" | jq -r '.info.points')
  difficulty=$(echo "$machine_response" | jq -r '.info.difficultyText')

  # Display machine details in Rofi
  selected_option=$(printf '%s\n' "Name: $name" "IP: $ip (Click to copy)" "Points: $points" "Difficulty: $difficulty" "Go Back" | rofi -config $active_mac -dmenu -p "Active Machine Details:")

case "$selected_option" in
  "Name: $name")
    ;;
  "IP: $ip (Click to copy)")
    echo -n "$ip" | xclip -selection clipboard
    ##xdotool key ctrl+shift+v  # Simulate paste keyboard shortcut
    ;;
  "Points: $points")
    ;;
  "Difficulty: $difficulty")
    ;;
  "Go Back")
    return
    ;;
esac
}



# Function to reset the active machine
function reset_machine() {
  local machine_id=$1

  # Get machine name from Hack The Box API
  machine_response=$(curl -s -H "Authorization: Bearer $appkey" "https://www.hackthebox.com/api/v4/machine/info/$machine_id")
  name=$(echo "$machine_response" | jq -r '.info.name')

  # Display confirmation message in Rofi
  confirmation=$(printf "Yes\nNo" | rofi -config $reset_prompt -dmenu -p  "Are you sure you want to reset the machine ' $name ' ?")

  if [[ "$confirmation" == "Yes" ]]; then
    # Make POST request to reset the machine
    reset_response=$(curl -s -X POST -H "Authorization: Bearer $appkey" -H "Content-Type: application/json" \
      -d "{\"machine_id\":$machine_id}" "https://www.hackthebox.com/api/v4/vm/reset")

    rofi -e "Machine reset request sent."
  fi
}

# Main menu options
options=("Active Machine Details" "Reset Machine" "Exit")

# Display the menu
selected_option=$(printf '%s\n' "${options[@]}" | rofi -cofig $rofidmenu -dmenu -p "Select an option:")

case "$selected_option" in
  "Active Machine Details")
    active_response=$(curl -s -H "Authorization: Bearer $appkey" "https://www.hackthebox.com/api/v4/machine/active")
    active_machine_id=$(echo "$active_response" | jq -r '.info.id')

    if [[ $active_machine_id == null ]]; then
      rofi -e "No active machine found."
      exit 1
    else
      show_machine_details "$active_machine_id"
    fi
    ;;

  "Reset Machine")
    active_response=$(curl -s -H "Authorization: Bearer $appkey" "https://www.hackthebox.com/api/v4/machine/active")
    active_machine_id=$(echo "$active_response" | jq -r '.info.id')

    if [[ $active_machine_id == null ]]; then
      rofi -e "No active machine found."
      exit 1
    else
      reset_machine "$active_machine_id"
    fi
    ;;

  "Exit")
    exit 0
    ;;
esac

