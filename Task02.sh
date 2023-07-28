#!/bin/bash

# Center Algin Text
centerAlign() {
    local text="$1"
    local terminal_width=$(tput cols)
    local text_width=${#text}

    # Calculate the number of spaces to add before and after the text
    local spaces_before=$(( (terminal_width - text_width) / 2 ))
    local spaces_after=$(( terminal_width - text_width - spaces_before ))

    # Print the centered text with spaces
    printf "%${spaces_before}s%s%${spaces_after}s\n" "" "$text" ""
}

# Validation for register condition
registerCondition() {
    echo -e "Register Another Patron? (y)es or (q)uit: \n" 
    read -p "Press (q) to return to ${bold}University Venue Management Menu. " newRegistration

    case $newRegistration in
        "y"|"Y")
            echo "Patron registered successfully!"
            registerPatron
            ;;
        "q"|"Q")
            echo "Main Menu"
            ;;
        *)
            echo "Please provide a valid choice!" 
            registerCondition
            ;;
    esac
}

# Register Patron
registerPatron() {
    # patronList = patron.txt
    echo
    echo "Patron Registration"
    echo "====================="

    read -p "Patron ID (As per TAR UMT format): " patronID
    # Regular Expression check to check student / Staff ID valid or not
    while true
    do
        if [[ $patronID =~ ^[0-9]{6}$ ]] || [[$patronID =~ ^[0-9]{4}$]]; then
            break
        else
            echo "Please provide a valid Patron ID (As per TAR UMT format): "
            read -p "Patron ID (As per TAR UMT format): " patronID
        fi
    done

    read -p "Patron Full Name (As per NRIC): " patronName
    # Name doesn't require regular expression

    read -p "Contact Number: " contactNumber
    # Malaysian style phone number 010-0000000 or 010-00000000
    while true
    do
        if [[ $contactNumber =~ ^[0-9]{3}-[0-9]{7,8}$ ]]; then
            break
        else
            echo "Please provide a valid Contact Number: "
            read -p "Contact Number: " contactNumber
        fi
    done

    read -p "Email Address (As per TAR UMT format): " email
    # TAR UMT's style of email address, either xxxxxx-xx00@student.tarc.edu.my or xxx@tarc.edu.my
    while true
    do
        if [[ $email =~ ^[a-z]+-[a-z]{2}[0-9]{2}@tarc\.edu\.my$ ]] || [[ $email =~ ^[a-z]@tarc\.edu\.my$ ]]; then
            break
        else
            echo "Please provide a valid Email Address (As per TAR UMT format): "
            read -p "Email Address (As per TAR UMT format): " email
        fi
    done


    echo "$patronID:$patronName:$contactNumber:$email" >> "./patron.txt"
    echo
    
    registerCondition
}

# Validation for search condition
searchCondition() {
    echo "Search Another Person? (y)es or (q)uit :"
    read "Press (q) to return to University Venue Management Menu. " searchAnother

    case $searchAnother in
        "y"|"Y")
            searchPatron
            ;;
        "q"|"Q")
            echo "Returning to Main Menu."
            ;;
        *)
            echo "Please provide a valid choice!" 
            searchCondition
            ;;
    esac
}

# Search Patron
searchPatron() {
    centerAlign "Search Patron Details"
    centerAlign "____________________"
    echo

    # Read data from patron.txt
    read -p "Enter Patron ID to search: " patronID 
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

    # readarray -t patronList < patron.txt
    # IFS=$'\n'

    # # Set loop number
    # counter=0
    # for getPatronList in ${patronList[@]}; do
    #     ((counter++))
    # done

    # # Search PatronID
    # for (( i=0; i<$counter; i++ )); do
    #     IFS=$'\n'
    #     for perItem in ${patronList[arrayCounter]}; do        
    #         IFS=$':'
    #         read -ra patronDetailsArray <<< $perItem
    #         if [ ${patronDetailsArray[0]} != $patronID ]; then  
    #             (( arrayCounter++ ))
    #         else
    #             arrayCounter=$arrayCounter
    #             (( i=3 ))
    #             # echo "Patron Details:" ${patronDetailsArray[@]}
    #             break
    #         fi
    #     done
    # done  

    # Display Patron details according patronID
    for i in {1..100}
    do
        printf "_"
    done
    echo
    echo "Full Name:" ${patronDetailsArray[1]}
    echo "Contact Number:" ${patronDetailsArray[2]}
    echo -e "Email Address (As per TAR UMT format):" ${patronDetailsArray[3]} "\n"
    echo 

    searchCondition
}