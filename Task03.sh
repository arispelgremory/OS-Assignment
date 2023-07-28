#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

# Function to get the terminal width
term_width() {
  tput cols
}

# Function to print centered text
print_centered() {
  local cols=$(term_width)
  local text_length=${#1}
  local half_input_length=$(( $text_length / 2 ))
  local half_terminal_width=$(( $cols / 2 ))
  local start_position=$(( $half_terminal_width - $half_input_length ))

  # Ensure start_position is not negative (occurs when text is longer than terminal width)
  if (( $start_position < 0 )); then
    start_position=0
  fi

  # Print spaces first using echo
  echo -n "$(seq -s " " $((start_position + 1)) | tr -d '[:digit:]')"
  # Then print the text
  echo "$1"

  # Print the underline using echo
  echo -n "$(seq -s " " $((start_position + 1)) | tr -d '[:digit:]')"
  echo "$(seq -s "=" $((text_length + 1)) | tr -d '[:digit:]')"
}

# Add Venue Funciton
AddVenue() {
    print_centered "Add New Venue"

    read -p "Block Name:" blockName
    
    read -p "Room Number:" roomNumber 
    read -p "Room Type:" roomType
    read -p "Capacity:" capacity
    read -p "Status (by default):" status
    status="Available"
    echo -e "\n"
    

    is_valid=0

    while [ $is_valid -eq 0 ]; do
        read -p "Add Another Venue? (y)es or (q)uit: " action  # Read new input

        if [ "$action" = "y" ] || [ "$action" = "Y" ]; then
            # Valid
            is_valid=1  # Set the variable to 1
            AddVenue 

        elif [ "$action" = "q" ] || [ "$action" = "Q" ]; then

            read -p "Press (q) to return to ${bold}University Venue Management Menu." quitResult
            is_valid=1  # Exit the loop

        else
            echo "Please provide a valid choice"
        fi
    done

}

AddVenue

