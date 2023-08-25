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
   
    while true; do
      read -p "${normal}Block Name:" blockName
      if [[ ! $blockName =~ ^[a-zA-Z]{1,3}$ ]]; then
        echo "Invalid Input, please try again"
      else
        break;
      fi
    done

    while true; do
      read -p "${normal}Room Number:" roomNumber
      if [[ ! $roomNumber =~ ^[a-zA-Z]{1,1}([a-zA-Z]{0,1}[0-9]{3}|[0-9]{3}[a-zA-Z]{0,1})$ ]]; then
        echo "Invalid Input, please try again"
      else
        break;
      fi
    done

    while true; do
      read -p "${normal}Room Type:" roomType
      if [[ ! $roomType == "Lecture Hall" || $roomType == "Tutorial Room" || $roomType == "Lab" ]]; then
        echo "Invalid Input, only accepts input such as:Lecture Hall, Tutorial Room and Lab."
      else
        break;
      fi
    done

    while true; do
      read -p "Capacity:" capacity
      if [[ ! $roomNumber =~ ^[a-zA-Z]{1,2}[0-9]{3}$ ]]; then
        echo "Invalid Input, please try again"
      else
        break;
      fi
    done

    read -p "Remarks:" remarks
    # Allow empty

    read -p "Status (by default): Available"
    status="Available" # Default is Available
    echo -e "\n"

    # Specify the file to read
    file="venue.txt"

    # Check if the file doesn't exists
    if [[ ! -f $file ]]; then
      echo "$file not found."
      echo "Creating $file."
      echo BlockName:RoomNumber:RoomType:Capacity:Remarks >> $file
    fi

    # Append data into venue.txt
    echo "$blockName:$roomNumber:$roomType:$capacity:$remarks" >> $file
    

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

while true; do
  read -p "Input A to read, B to Add, Q to quit:" $option
  case $option in
    "A"|"a")
      echo "Read"
      ;;
    "B"|"b")
      echo "Add"
      AddVenue
      ;;
    "Q"|"q")
      echo "Quit"
      break;
      ;;
    *)
      echo "Invalid Input, please try again"
      ;;
  esac
done

