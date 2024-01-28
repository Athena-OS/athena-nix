#!/usr/bin/env bash

export  appkey=$(secret-tool lookup htb-api user-htb-api)

lowercase_filter() {
    tr '[:upper:]' '[:lower:]'
}

rhtb=$HOME/.config/rofi/htb/
#!/usr/bin/env bash
spawnrasi=$rhtb/rasi/spawn.rasi
# normal rofi menu w
rofidmenu=$rhtb/rasi/dmenu.rasi
# rofi config for password
rofipass=$rhtb/rasi/passwd.rasi

# Function to display the main menu
show_main_menu() {
    options=("Select Machine To Spawn 👨‍💻 " "Submit Flag 🏁 " "Stop Active Machine 🔪 ")

    # Use Rofi to display the main menu and store the selected index
    selected=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Hack The Box Menu:" -format i)

    case "$selected" in
    0)
        # Select Machine option is chosen, show the machine selection menu
        show_machine_menu
        ;;
    1)
        # Submit Flag option is chosen, show the flag submission menu
        show_flag_menu
        ;;
    2)
        # Terminate option is chosen, make a request to terminate the active machine
        terminate_active_machine
        ;;
    esac
}


# Function to display the machine selection menu
show_machine_menu() {
    # Run the command and store the output in a variable
    output=$(curl -X GET https://www.hackthebox.com/api/v4/machine/list -H "Authorization: Bearer $appkey" | jq -r '.info[] | [.id, .name, .difficultyText, .os] | @tsv')

    # Create an array to store the menu items and ids
    menu_items=()
    ids=()

    # Iterate over each line of the output and add it to the menu_items array and ids array
    while IFS=$'\t' read -r id name difficulty os; do
        # Map OS names to "win" or "lin"
        case "$os" in
        "Windows")
            os_short=""
            ;;
        "Linux")
            os_short=""
            ;;
        *)
            os_short=""
            ;;
        esac

        menu_items+=("$name ($difficulty) $os_short")
        ids+=("$id")
    done <<<"$output"

    # Use Rofi to display the machine menu and store the selected index
    selected=$(printf "%s\n" "${menu_items[@]}" | lowercase_filter | rofi -dmenu -p "Select a machine:" -format i -no-custom)

    # Check if a selection was made
    if [[ -n "$selected" ]]; then
        # Extract the selected id
        selected_id="${ids[$selected]}"

        # Display the submenu using Rofi and store the selected option
        submenu_options=("Yes" "No")
        submenu_selected=$(printf "%s\n" "${submenu_options[@]}" | rofi -config $rofidmenu  -dmenu -p "You want to spawn this machine:" -format i -no-custom)

        case "$submenu_selected" in
        0)
            # User selected "Yes," make a request based on the selected id
            curl -X POST "https://www.hackthebox.com/api/v4/machine/play/$selected_id" -H "Authorization: Bearer $appkey"
            ;;
        1)
            # User selected "No," do nothing
            ;;
        esac
    fi

    # Close the Rofi menu
    echo ""
    show_main_menu
}













# Function to display the flag submission menu
show_flag_menu() {
    # Run the command and store the output in a variable
    output=$(curl -X GET https://www.hackthebox.com/api/v4/machine/list -H "Authorization: Bearer $appkey" | jq -r '.info[] | [.id, .name, .os] | @tsv')

    # Create an array to store the menu items and ids
    menu_items=()
    ids=()

    # Iterate over each line of the output and add it to the menu_items array and ids array
    while IFS=$'\t' read -r id name os; do
        # Map OS names to symbols
        case "$os" in
        "Windows")
            os_symbol=""
            ;;
        "Linux")
            os_symbol=""
            ;;
        *)
            os_symbol=""
            ;;
        esac

        menu_items+=("$name $os_symbol")
        ids+=("$id")
    done <<<"$output"

    # Use Rofi to display the machine menu and store the selected index
    selected=$(printf "%s\n" "${menu_items[@]}" | lowercase_filter | rofi -dmenu -p "Select a machine:" -format i -no-custom)

 # Check if a selection was made
    if [[ -n "$selected" ]]; then
        # Extract the selected id
        selected_id="${ids[$selected]}"

        # Display the flag input using Rofi and store the entered flag
        flag=$( rofi -config $rofipass -dmenu -i -p "Enter The Flag:")

        # Make a request to submit the flag and capture the HTTP status code and response
        response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "https://www.hackthebox.com/api/v4/machine/own" -H "Authorization: Bearer $appkey"  -H "Content-Type: application/json"  --data "{\"id\": \"$selected_id\", \"flag\": \"$flag\",\"difficulty\":\"50\"}")

        # Capture the API response message
        response_message=$(curl -s -X POST "https://www.hackthebox.com/api/v4/machine/own" -H "Authorization: Bearer $appkey"  -H "Content-Type: application/json"  --data "{\"id\": \"$selected_id\", \"flag\": \"$flag\",\"difficulty\":\"50\"}" | jq -r '.message')

        # Display appropriate message based on HTTP status code and response message
        if [[ "$response" == "200" ]]; then
            rofi -config $rofidmenu -e "Correct Flag"
        elif [[ "$response_message" == *"Incorrect flag!"* ]]; then
            rofi -config $rofidmenu -e "Wrong Flag"
        elif [[ "$response_message" == *"is already owned."* ]]; then
            rofi -config $rofidmenu -e "Flag is already submitted"
        else
            rofi -config $rofidmenu -e "Unknown response: $response_message"
        fi
    fi

    # Close the Rofi menu
    echo ""
    show_main_menu
}















# Function to terminate the active machine
terminate_active_machine() {
    # Display a confirmation dialog using Rofi
    confirm=$(echo -e "Yes\nNo" | rofi  -config $rofidmenu -dmenu -p "Stop playing the active machine?" -format i)

    # If "Yes" is selected, make the request to terminate the machine
    if [[ "$confirm" == 0 ]]; then
        curl -X POST "https://www.hackthebox.com/api/v4/machine/stop" -H "Authorization: Bearer $appkey"
    fi

    # Show the main menu after terminating the active machine
    show_main_menu
}

# Start the main menu
show_main_menu

