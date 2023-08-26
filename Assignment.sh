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

# Task04.sh
# Validation for venue condition
BookingVenueCondition() {
    read -p "Press ${bold}(s) ${normal}to save and generate the venue booking details or Press ${bold}(c) ${normal} to cancel the Venue Booking and return to University Venue Management Menu:" newBooking

    case $newBooking in
        "s"|"S")
            echo "Venue Book Successfully!"
            echo "$patronID:$bookingDate:$timeDurationFrom:$timeDurationTo:$reasons" >> "./booking.txt"
            ;;
        "c"|"C")
            echo "Venue Booking Cencelled."
            echo "Returning to Main Menu."
            MainMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            BookingVenueCondition
            ;;
    esac
}

# Booking Venue
BookingVenue() {
    print_centered "Booking Venue"

    read -p "Please enter the Room Number: " roomNumber

    echo "Room Type:" $labType
    echo "Capacity:" $capacity
    echo "Remarks:" $remarks
    echo -e "Status:" $status "\n"

    echo "Notes: The booking hours shall be from 8am to 8pm only. The booking duration shall be at least 30 minuts per booking."

    echo -e "\nPlease ${bold}enter ${normal}the following details:\n"

    while true; do
        read -p "Booking Date (mm/dd/yy): " bookingDate
        if [[ $bookingDate =~ ^(0[1-9]|1[0-2])\/(0[1-9]|[12][0-9]|3[01])\/([0-9]{2})$ ]]; then
            break;
        else
            echo "Invalid date format. Please enter in the format mm/dd/yy."
        fi
    done;

    while true; do
        read -p "Time From (hh:mm): " timeDurationFrom

        if [[ !$timeDurationFrom =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
            echo "Invalid time format. Please enter in the format hh:mm."
        else
            break;
        fi
    done;

    while true; do
        read -p "Time to (hh:mm): " timeDurationTo
        if [[ !$timeDurationTo =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
            echo "Invalid time format. Please enter in the format hh:mm."
        else
            break
        fi
    done;
    
    read -p "Reasons for Booking: " reasons
    # Only checks for whether it is empty or not
    while true; do
        if [[ -z $reasons ]]; then
            echo "Please provide a valid Reasons for Booking: "
            read -p "Reasons for Booking: " reasons
        else
            break
        fi
    done

    BookingVenueCondition
    # echo "$patronID:$bookingDate:$timeDurationFrom:$timeDurationTo:$reasons" >> "./booking.txt"
}

# Validation for patron details condition
patronDetailsCondition() {
    read -p "Press (n) to proceed Book Venue or (q) to return to University Venue Management Menu:" proceedBooking 

    case $proceedBooking in
        "n"|"n")
            bookingVenue
            ;;
        "q"|"Q")
            echo -e "Returning to Main Menu.\n"
            MainMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            patronDetailsCondition
            ;;
    esac
}

# Patron Details Validation
patronDetailsValidation() {
    echo "Patron Details Validation"
    echo "==========================="

    # Read data from patron.txt
    read -p "Please enter Patron's ID Number: " patronID
    while true
    do
        if [[ $patronID =~ ^[0-9]{6}$ ]] || [[ $patronID =~ ^[0-9]{4}$ ]]; then
            break
        else
            echo "Please provide a valid Patron ID (As per TAR UMT format): "
            read -p "Patron ID (As per TAR UMT format): " patronID
        fi
    done

    if [ ! -f patron.txt ]; then
        echo "Error: patron.txt file does not exist in the current directory."
        return
    fi

    # Search with PatronID
    patronDetails=$(grep "^$patronID:" patron.txt)

    if [ -z "$patronDetails" ]; then
        echo "Error: No patron found with ID $patronID."
        return
    fi

    IFS=":"
    read -ra patronDetailsArray <<< "$patronDetails"

    echo
    echo "Patron Name:" ${patronDetailsArray[1]}
    echo
}

# Task03.sh
# Add Venue Funciton
AddVenue() {
    print_centered "Add New Venue"
   
    while true; do
      read -p "${normal}Block Name:" blockName
      if [[ ! $blockName =~ ^[a-zA-Z]{1,3}$ ]]; then
        echo "Invalid Input, please try again"
      else
        # Convert lower case to upper case
        blockName=$(echo -e $blockName | tr '[a-z]' '[A-Z]')
        break;
      fi
    done

    while true; do
      read -p "${normal}Room Number:" roomNumber
      if [[ ! $roomNumber =~ ^[a-zA-Z]{1,3}([a-zA-Z]{0,1}[0-9]{3}|[0-9]{3}[a-zA-Z]{0,1})$ ]]; then
        echo "Invalid Input, please try again"
      else
        # Convert lower case to upper case
        roomNumber=$(echo -e $roomNumber | tr '[a-z]' '[A-Z]')
        break;
      fi
    done

    while true; do
      read -p "${normal}Room Type:" roomType
      if [[ ! ($roomType == "Lecture Hall" || $roomType == "Tutorial Room" || $roomType == "Lab") ]]; then
        echo "Invalid Input, only accepts input such as:Lecture Hall, Tutorial Room and Lab."
      else
        break;
      fi
    done

    while true; do
        read -p "Capacity: " capacity
        if [[ ! $capacity =~ ^[0-9]+$ ]]; then
            echo "Invalid Input, please enter a valid number for capacity."
        else
            break
        fi
    done


    read -p "Remarks:" remarks
    # Allow empty

    echo -e "Status (by default): Available\n"
    status="Available" # Default is Available

    echo -e "\n"

    # Specify the file to read
    file="venue.txt"

    # Check if the file doesn't exists
    if [[ ! -f $file ]]; then
      echo "$file not found."
      echo "Creating $file."
      echo BlockName:RoomNumber:RoomType:Capacity:Remarks:Status >> $file
    fi

    # Append data into venue.txt
    echo "$blockName:$roomNumber:$roomType:$capacity:$remarks:$status" >> $file
    

    is_valid=0
    while [ $is_valid -eq 0 ]; do
        read -p "Add Another Venue? (y)es or (q)uit: " action  # Read new input

        if [ "$action" = "y" ] || [ "$action" = "Y" ]; then
            # Valid
            is_valid=1  # Set the variable to 1
            AddVenue 

        elif [ "$action" = "q" ] || [ "$action" = "Q" ]; then
            BackToMenu
            break;
        else
            echo "Please provide a valid choice"
        fi
    done

}

SearchVenue() {
    print_centered "List Venue Details"

    # Specify the block
    while true; do
        read -p "Please enter the Block Name: " blockName
        if [[ ! $blockName =~ ^[a-zA-Z]{1,3}$ ]]; then
            echo "Invalid Input, please try again"
        else
            break;
        fi
    done;

    # Make the blockName become Uppercase
    blockName=$(echo -e $blockName | tr '[a-z]' '[A-Z]')

    # Specify the file to read
    file="venue.txt"

    # If venue.txt not found, go back
    if [[ ! -f $file ]]; then
        echo "$file not found."
        return
    fi

    # Print out the first line and remove the block name, then replace \t with :
    header=$(grep "BlockName" $file |  sed 's/^BlockName://' | tr ':' '\t')
    echo $header

    # Read data that starts with blockName
    venueDetails=$(grep "^$blockName:" $file | tr '\n' ',' )
    format_data "$venueDetails"
}

format_data() {
    local data="$1"

    # Define a function to print a divider line
    print_divider() {
        echo "+$(head -c $1 < /dev/zero | tr '\0' '-')+$(head -c $2 < /dev/zero | tr '\0' '-')+$(head -c $3 < /dev/zero | tr '\0' '-')+$(head -c $4 < /dev/zero | tr '\0' '-')+"
    }

    # Column widths
    ROOM_NUM_WIDTH=11
    ROOM_TYPE_WIDTH=20
    CAPACITY_WIDTH=9
    REMARKS_WIDTH=30
    STATUS_WIDTH=12

    # Print header
    print_divider $ROOM_NUM_WIDTH $ROOM_TYPE_WIDTH $CAPACITY_WIDTH $REMARKS_WIDTH
    echo "| RoomNumber | RoomType            | Capacity | Remarks                       | Status      |"
    print_divider $ROOM_NUM_WIDTH $ROOM_TYPE_WIDTH $CAPACITY_WIDTH $REMARKS_WIDTH

    # Convert comma-separated records to array
    IFS=',' read -ra records <<< "$data"
    for record in "${records[@]}"; do
        if [ -n "$record" ]; then
            IFS=':' read -r _ roomNumber roomType capacity remarks status <<< "$record"  # The underscore _ is a throwaway variable
            echo "| ${roomNumber}$(head -c $(($ROOM_NUM_WIDTH - ${#roomNumber} - 1)) < /dev/zero | tr '\0' ' ') | ${roomType}$(head -c $(($ROOM_TYPE_WIDTH - ${#roomType} - 1)) < /dev/zero | tr '\0' ' ') | ${capacity}$(head -c $(($CAPACITY_WIDTH - ${#capacity} - 1)) < /dev/zero | tr '\0' ' ') | ${remarks}$(head -c $(($REMARKS_WIDTH - ${#remarks} - 1)) < /dev/zero | tr '\0' ' ') | ${status}$(head -c $(($STATUS_WIDTH - ${#status} - 1)) < /dev/zero | tr '\0' ' ') |"
        fi
    done

    # Print footer
    print_divider $ROOM_NUM_WIDTH $ROOM_TYPE_WIDTH $CAPACITY_WIDTH $REMARKS_WIDTH

    while true; do

        read -p "Search Another Venue? (y)es or (q)uit: " action  # Read new input

        if [ "$action" = "y" ] || [ "$action" = "Y" ]; then
            # Valid
            SearchVenue

        elif [ "$action" = "q" ] || [ "$action" = "Q" ]; then

            BackToMenu;
        else
            echo "Please provide a valid choice"
        fi
    done
}

BackToMenu() {
    echo -e "Press (q) to return to ${bold}University Venue Management Menu."
    read quitResult

    case $quitResult in
        "q"|"Q")
            MainMenu
            ;;
        *)
            echo "Please provide a valid choice!"
            BackToMenu
            ;;
    esac
}

# Task02.sh

# Validation for register condition
registerCondition() {
    echo -e "Register Another Patron? (y)es or (q)uit: \n" 
    read -p "Press (q) to return to ${bold}University Venue Management Menu. " newRegistration

    case $newRegistration in
        "y"|"Y")
            echo "Patron registered successfully!"
            RegisterPatron
            ;;
        "q"|"Q")
            MainMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            registerCondition
            ;;
    esac
}

# Register Patron
RegisterPatron() {
    echo "Patron Registration"
    echo "====================="

    # Regular Expression check to check student / Staff ID valid or not
    while true; do
        read -p "Patron ID (As per TAR UMT format): " patronID
        if [[ $patronID =~ ^[0-9]{6}$ ]] || [[ $patronID =~ ^[0-9]{4}$ ]]; then
            break
        else
            echo "Please provide a valid Patron ID (As per TAR UMT format)."
        fi
    done

    # Name accepts character inputs
    while true; do
        read -p "Patron Full Name (As per NRIC): " patronName

        if [[ $patronName=~"^[A-Za-z\s'-]+$" ]]; then
            break
        else
            echo "Invalid name. Please use only letters, spaces, hyphens, and apostrophes."
        fi
    done

    # Malaysian style phone number 010-0000000 or 010-00000000
    while true; do
        read -p "Contact Number: " contactNumber
        if [[ $contactNumber =~ ^[0-9]{3}-[0-9]{7,8}$ ]]; then
            break
        else
            echo "Please provide a valid Contact Number."
        fi
    done

    # TAR UMT's style of email address
    while true; do
        read -p "Email Address (As per TAR UMT format): " email
        if [[ $email =~ ^[a-z]+-[a-z]{2}[0-9]{2}@student\.tarc\.edu\.my$ ]] || [[ $email =~ ^[a-z]+@tarc\.edu\.my$ ]]; then
            break
        else
            echo "Please provide a valid Email Address (As per TAR UMT format)."
        fi
    done

    echo "$patronID:$patronName:$contactNumber:$email" >> "./patron.txt"
    echo
    
    registerCondition
}

# Validation for search condition
searchCondition() {
    echo "Search Another Person? (y)es or (q)uit :"
    read -p "Press (q) to return to University Venue Management Menu. " searchAnother

    case $searchAnother in
        "y"|"Y")
            SearchPatron
            ;;
        "q"|"Q")
            echo "Returning to Main Menu."
            MainMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            searchCondition
            ;;
    esac
}

# Search Patron
SearchPatron() {
    echo "Search Patron Details"
    echo "____________________"
    echo

    # Read data from patron.txt
    while true; do
        read -p "Enter Patron ID to search: " patronID 
        if [[ $patronID =~ ^[0-9]{6}$ ]] || [[ $patronID =~ ^[0-9]{4}$ ]]; then
            break
        else
            echo "Please provide a valid Patron ID (As per TAR UMT format)."
        fi
    done

    if [ ! -f patron.txt ]; then
        echo "Error: patron.txt file does not exist in the current directory."
        return
    fi

    # Search with PatronID
    patronDetails=$(grep "^$patronID:" patron.txt)

    if [ -z "$patronDetails" ]; then
        echo "Error: No patron found with ID $patronID."
        return
    fi

    IFS=":"
    read -ra patronDetailsArray <<< "$patronDetails"

    # Display Patron details according to patronID
    echo
    echo "Full Name:" ${patronDetailsArray[1]}
    echo "Contact Number:" ${patronDetailsArray[2]}
    echo -e "Email Address (As per TAR UMT format):" ${patronDetailsArray[3]} "\n"
    echo 

    searchCondition
}

# Task01.sh
MainMenu() {
    clear
    echo -e "${bold}University Venue Management Menu${normal}\n"
    echo -e "A – Register New Patron\nB – Search Patron Details\nC – Add New Venue\nD – List Venue\nE – Book Venue"
    echo -e "\nQ – Exit from Program\n"
    echo -e "Please select a choice: "
    read choice

    choice=$(echo -e $choice | tr '[a-z]' '[A-Z]')
    echo -e "You have selected ${choice}\n"

    case $choice in
        "A" | "a")
            RegisterPatron
            # bash Task02.sh;
            ;;
        "B" | "b")
            # echo "Search Patron Details\n"
            SearchPatron
            ;;
        "C" | "c")
            # echo "Add New Venue\n"
            AddVenue
            ;;
        "D" | "d")
            # echo "List Venue\n"
            SearchVenue
            ;;
        "E" | "e")
            # echo "Book Venue\n"
            BookingVenue
            ;;
        "Q" | "q")
            echo -e "Thank you for using University Venue Management Menu System\n"
            exit 98;
            ;;
        *)
            echo -e "Invalid Choice\n"
            MainMenu
            ;;
    esac

}

MainMenu