#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Function to check id
ValidateID() {
    local id=$1

    # Regex pattern for Staff ID and Student ID
    if [[ ! $id =~ ^\d{4}$ && ! $id =~ ^\d{2}[A-Z]{3}\d{5}$ ]]; then
        echo "Invalid ID format. Please ensure you're using either a staff or student TAR UC ID format."
        return 1
    fi

    return 0
}

# Function to check email
ValidateEmail() {
    local email=$1

    # Regex pattern for email
    if [[ ! $email =~ ^[a-z]+-[a-z]{2}[0-9]{2}@student\.tarc\.edu\.my$ && ! $email =~ ^[a-z]+@tarc\.edu\.my$ ]]; then
        echo "Invalid email format. Please ensure you're using either a staff or student TAR UC email format."
        return 1
    fi
    return 0
}


# Function to get the terminal width
TermWidth() {
  tput cols
}

# Function to print centered text
PrintCentered() {
  local cols=$(TermWidth)
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
# Generate Receipt
GenerateReceipt() {
    local patronID=$1
    local patronName=$2
    local roomNumber=$3
    local dateBooking=$4
    local timeFrom=$5
    local timeTo=$6
    local reason=$7

    # Define the width of the receipt
    width=80

    # Function to print a centered string
    print_centered() {
        local str="$1"
        local total_length="${#str}"
        local left_padding=$(( (width - total_length) / 2 ))
        local right_padding=$(( width - total_length - left_padding ))
        printf "|%*s%s%*s|\n" "$left_padding" "" "$str" "$right_padding" ""
    }

    currentDate=$(date +"%-m-%-d-%Y")
    currentTime=$(date +"%I.%M%p")
    fileName="${patronID}_${roomNumber}_${currentDate}.txt"
    touch $fileName
    {
        # Print the receipt
        echo "+$(printf '%.s-' {1..80})+"
        print_centered "Venue Booking Receipt"
        echo "|$(printf '%.s ' {1..80})|"
        # Invoke for Patron ID and Name on the same line
        combined_info="Patron ID : $patronID   Patron Name : $patronName"
        print_centered "$combined_info"
        print_centered "Room Number : $roomNumber"
        print_centered "Date Booking: $dateBooking"

        combined_info2="Time From: $timeFrom   Time To: $timeTo"
        print_centered "$combined_info2"

        print_centered "Reason for Booking: $reason"
        echo "|$(printf '%.s ' {1..80})|"
        print_centered "This is a computer generated"
        print_centered "receipt with no signature required."

        print_centered "Printed on $currentDate $currentTime"
        echo "+$(printf '%.s-' {1..80})+"
    } > $fileName

    # Move file into booking receipt folder
    if [ ! -d booking_receipts ]; then
        mkdir booking_receipts
    fi
    mv $fileName booking_receipts
    
}

# Validation for venue condition
BookingVenueCondition() {
    local patronID=$1
    local bookingVenue=$2

    read -p "Press ${bold}(s) ${normal}to save and generate the venue booking details or Press ${bold}(c) ${normal} to cancel the Venue Booking and return to University Venue Management Menu:" newBooking

    case $newBooking in
        "s"|"S")
            echo "Venue Book Successfully!"
            echo "$patronID:$bookingDate:$timeDurationFrom:$timeDurationTo:$reasons" >> "./booking.txt"
            GenerateReceipt $patronID $patronName $roomNumber $bookingDate $timeDurationFrom $timeDurationTo $reasons
            MainMenu
            ;;
        "c"|"C")
            echo "Venue Booking Cancelled."
            echo "Returning to Main Menu."
            MainMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            BookingVenueCondition $patronID $patronName
            ;;
    esac
}

# Check duplicated data for venue
ValidateBooking() {
    local patronID=$1
    local roomNumber=$2
    local bookingDate=$3
    local timeDurationFrom=$4
    local timeDurationTo=$5

    # Convert times to minutes for easier comparison
    start_time_minutes=$(ToMinutes "$timeDurationFrom")
    end_time_minutes=$(ToMinutes "$timeDurationTo")

    # Check if the venue is already booked at the desired date and time
    while IFS= read -r line; do
        # Extract details from each booking line
        local bookedPatronID=$(echo $line | cut -d':' -f1)
        local bookedRoomNumber=$(echo $line | cut -d':' -f2)
        local bookedDate=$(echo $line | cut -d':' -f3)
        local bookedTimeFrom=$(echo $line | cut -d':' -f4)
        local bookedTimeTo=$(echo $line | cut -d':' -f5)

        # Convert booked times to minutes
        booked_start_time_minutes=$(ToMinutes "$bookedTimeFrom")
        booked_end_time_minutes=$(ToMinutes "$bookedTimeTo")

        # Check venue booking overlap
        if [[ "$roomNumber" == "$bookedRoomNumber" && "$bookingDate" == "$bookedDate" ]]; then
            if (( booked_start_time_minutes < end_time_minutes && booked_end_time_minutes > start_time_minutes )); then
                echo "Venue is already booked for the desired time slot. Please choose another venue."
                return 1
            fi
        fi

        # Check patron multiple bookings
        if [[ "$patronID" == "$bookedPatronID" && "$bookingDate" == "$bookedDate" ]]; then
            if (( booked_start_time_minutes < end_time_minutes && booked_end_time_minutes > start_time_minutes )); then
                echo "You already have a booking at the desired time slot."
                return 1
            fi
        fi
    done < booking.txt

    return 0
}

# Booking Venue
BookingVenue() {
    local patronID=$1
    local patronName=$2

    PrintCentered "Booking Venue"

    while true; do
        read -p "Please enter the Room Number:" roomNumber
        
        # Check against the regex pattern first
        if [[ ! $roomNumber =~ ^(?:[A-Z]{1,2}[1-3]?[0-9]{0,3}[A-Z]?|DK[1-8]|DK[A-Z]|DKAB[A-F]|DKS[A-Z]|DKSG[1-6])$ ]]; then
            echo "Invalid room number format. Please enter a valid TAR UC room number."
        else
            # Convert lower case to upper case
            roomNumber=$(echo -e $roomNumber | tr '[a-z]' '[A-Z]')
            
            # Check if the room number exists in venue.txt
            if ! grep -q "$roomNumber" venue.txt; then
                echo "The room number you entered does not exist. Please check and try again."
            # Check if the booking is valid
            elif ! ValidateBooking $patronID $roomNumber $bookingDate $timeDurationFrom $timeDurationTo; then
                echo "The room number is already booked for the specified date and time. Please choose a different slot or room."
            else
                break
            fi
        fi
    done

    # Grab data from venue.txt
    roomDetails=$(grep "$roomNumber" venue.txt)

    # Read Room Number's data
    if [[ ! $roomDetails ]] ;then
        echo "Error: No room found with Room Number $roomNumber."
        BookingVenue $patronID $patronName
        return
    fi

    IFS=':' read -r _ roomNumber roomType capacity remarks status <<< "$roomDetails"  # The underscore _ is a throwaway variable

    echo "Room Type: $roomType" 
    echo "Capacity: $capacity" 
    echo "Remarks: $remarks" 
    echo -e "Status: $status\n"

    echo "Notes: The booking hours shall be from 8am to 8pm only. The booking duration shall be at least 30 minuts per booking."

    echo -e "\nPlease ${bold}enter ${normal}the following details:\n"

    # Function to convert date mm/dd/yy to Julian Day Number (JDN)
    DateToJDN() {
        local date="$1"
        local month="${date%%/*}"
        date="${date#*/}"
        local day="${date%%/*}"
        local year="20${date##*/}"  # Assuming 2000s for yy format

        # Formula to convert Gregorian date to JDN
        month=10#$month
        day=10#$day
        year=10#$year
        
        result=$(( day + (153*(month + 12*((14 - month)/12) - 3) + 2)/5 + (365*(year + 4800 - (14 - month)/12)) + year/4 - year/100 + year/400 - 32045 ))
        
        echo $result
    }

    while true; do
        read -p "Booking Date (mm/dd/yy): " bookingDate

        if [[ $bookingDate =~ ^(0[1-9]|1[0-2])\/(0[1-9]|[12][0-9]|3[01])\/([0-9]{2})$ ]]; then
            # Convert both the current date and booking date to JDN for comparison
            current_jdn=$(DateToJDN $(date +"%m/%d/%y"))
            booking_jdn=$(DateToJDN "$bookingDate")

            if (( booking_jdn <= current_jdn )); then
                echo "Booking date must be at least one day in the future. Please enter a valid date."
            else
                break
            fi
        else
            echo "Invalid date format. Please enter in the format mm/dd/yy."
        fi
    done

    ToMinutes() {
        local time="$1"
        local hours="${time%:*}"
        local minutes="${time#*:}"
        echo $((hours * 60 + minutes))
    }

    while true; do
        read -p "Time From (hh:mm): " timeDurationFrom

        if [[ ! $timeDurationFrom =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
            echo "Invalid time format. Please enter in the format hh:mm."
        else
            break
        fi
    done

    while true; do
        read -p "Time to (hh:mm): " timeDurationTo
        if [[ ! $timeDurationTo =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ ]]; then
            echo "Invalid time format. Please enter in the format hh:mm."
        else
            # Convert times to minutes for comparison
            start_time_minutes=$(ToMinutes "$timeDurationFrom")
            end_time_minutes=$(ToMinutes "$timeDurationTo")

            if (( end_time_minutes <= start_time_minutes )); then
                echo "End time cannot be earlier than or equal to the start time. Please enter again."
            else
                break
            fi
        fi
    done

    # Don't check
    read -p "Reasons for Booking: " reasons

    echo "Booking Venue: $roomNumber"
    BookingVenueCondition $patronID $patronName 
}

# Validation for patron details condition
PatronDetailsCondition() {
    local patronID=$1
    local patronName=$2

    read -p "Press ${bold}(n)${normal} to proceed ${bold}Book Venue${normal} or ${bold}(q)${normal} to return to ${bold}University Venue Management Menu${normal}:" proceedBooking 

    case $proceedBooking in
        "n"|"n")
            BookingVenue $patronID $patronName
            ;;
        "q"|"Q")
            echo -e "Returning to Main Menu.\n"
            MainMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            PatronDetailsCondition $patronID $patronName
            PatronDetailsCondition $patronID $patronName
            ;;
    esac
}

# Patron Details Validation
PatronDetailsValidation() {
    echo "Patron Details Validation"
    echo "==========================="

    # Read data from patron.txt
    read -p "Please enter Patron's ID Number: " patronID
    while true; do
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

    echo -e "\nPatron Name:${patronDetailsArray[1]}\n" 

    PatronDetailsCondition $patronID ${patronDetailsArray[1]}
}}

# Task03.sh
# Add Venue Funciton
AddVenue() {
    PrintCentered "Add New Venue"
   
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
    PrintCentered "List Venue Details"

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

    # Read data that starts with blockName
    venueDetails=$(grep "^$blockName:" $file | tr '\n' ',' )
    FormatData "$venueDetails"
}

FormatData() {
    local data="$1"

    # Define a function to print a divider line
    PrintDivider() {
        echo "+$(head -c $1 < /dev/zero | tr '\0' '-')+$(head -c $2 < /dev/zero | tr '\0' '-')+$(head -c $3 < /dev/zero | tr '\0' '-')+$(head -c $4 < /dev/zero | tr '\0' '-')+"
    }

    # Column widths
    ROOM_NUM_WIDTH=11
    ROOM_TYPE_WIDTH=20
    CAPACITY_WIDTH=9
    REMARKS_WIDTH=30
    STATUS_WIDTH=12

    # Print header
    PrintDivider $ROOM_NUM_WIDTH $ROOM_TYPE_WIDTH $CAPACITY_WIDTH $REMARKS_WIDTH
    echo "| RoomNumber | RoomType            | Capacity | Remarks                       | Status      |"
    PrintDivider $ROOM_NUM_WIDTH $ROOM_TYPE_WIDTH $CAPACITY_WIDTH $REMARKS_WIDTH

    # Convert comma-separated records to array
    IFS=',' read -ra records <<< "$data"
    for record in "${records[@]}"; do
        if [ -n "$record" ]; then
            IFS=':' read -r _ roomNumber roomType capacity remarks status <<< "$record"  # The underscore _ is a throwaway variable
            echo "| ${roomNumber}$(head -c $(($ROOM_NUM_WIDTH - ${#roomNumber} - 1)) < /dev/zero | tr '\0' ' ') | ${roomType}$(head -c $(($ROOM_TYPE_WIDTH - ${#roomType} - 1)) < /dev/zero | tr '\0' ' ') | ${capacity}$(head -c $(($CAPACITY_WIDTH - ${#capacity} - 1)) < /dev/zero | tr '\0' ' ') | ${remarks}$(head -c $(($REMARKS_WIDTH - ${#remarks} - 1)) < /dev/zero | tr '\0' ' ') | ${status}$(head -c $(($STATUS_WIDTH - ${#status} - 1)) < /dev/zero | tr '\0' ' ') |"
        fi
    done

    # Print footer
    PrintDivider $ROOM_NUM_WIDTH $ROOM_TYPE_WIDTH $CAPACITY_WIDTH $REMARKS_WIDTH

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
    read -p "Press (q) to return to ${bold}University Venue Management Menu." quitResult

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
RegisterCondition() {
    read -p "Register Another Patron? (y)es or (q)uit: "  newRegistration

    case $newRegistration in
        "y"|"Y")
            echo "Patron registered successfully!"
            RegisterPatron
            ;;
        "q"|"Q")
            BackToMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            RegisterCondition
            ;;
    esac
}

# Register Patron
RegisterPatron() {
    echo "Patron Registration"
    echo "====================="

    # Regular Expression check to check student / Staff ID valid or not
    while true; do
        read -p "Patron ID (00XXX00000 or 0000): " patronID
        if [[ $patronID =~ ^[0-9]{6}$ ]] || [[ $patronID =~ ^[0-9]{4}$ ]]; then
            # Check if the ID is already in patrons.txt
            if grep -q "^$patronID:" patrons.txt; then
                echo "This ID has already been registered. Please log in or use a different ID."
                continue
            fi
            break
        else
            echo "Please provide a valid Patron ID (00XXX00000 or 0000)."
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
        if [[ $contactNumber =~ ^01[0-9]{1}-[0-9]{7,8}$ ]]; then
            break
        else
            echo "Please provide a valid Contact Number in the format of 01X-XXXXXXX."
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
    
    RegisterCondition
}

# Validation for search condition
SearchCondition() {
    read -p "Search Another Person? (y)es or (q)uit :" searchAnother

    case $searchAnother in
        "y"|"Y")
            SearchPatron
            ;;
        "q"|"Q")
            BackToMenu
            ;;
        *)
            echo "Please provide a valid choice!" 
            SearchCondition
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
        SearchPatron
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

    SearchCondition
}

# Task01.sh
MainMenu() {
    clear
    echo -e "${bold}University Venue Management Menu${normal}\n"
    echo -e "A – Register New Patron\nB – Search Patron Details\nC – Add New Venue\nD – List Venue\nE – Book Venue"
    echo -e "\nQ – Exit from Program\n"
    read -p "Please select a choice: " choice

    choice=$(echo -e $choice | tr '[a-z]' '[A-Z]')
    echo -e "You have selected ${choice}\n"

    case $choice in
        "A" | "a")
            RegisterPatron
            
            ;;
        "B" | "b")
            SearchPatron
            ;;
        "C" | "c")
            AddVenue
            ;;
        "D" | "d")
            SearchVenue
            ;;
        "E" | "e")
            PatronDetailsValidation
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
