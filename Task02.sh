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

# Register Patron
registerPatron() {
    # patronList = patron.txt

    echo "Patron Registration"
    echo "==================="

    read -p "Patron ID (As per TAR UMT format): " patronID
    read -p "Patron Full Name (As per NRIC): " patronName
    read -p "Contact Number: " contactNumber
    read -p "Email Address (As per TAR UMT format): " email
    echo -e "$patronID:$patronName:$contactNumber:$email" >> ".\patron.txt\n"

    echo read -p "Register Another Patron? (y)es or (q)uit: " newRegistration 
    

    echo "Press (q) to return to University Venue Management Menu." 
    read mainMenu
}

# Search Patron
searchPatron() {
    centerAlign "Search Patron Details"
    centerAlign "____________________"
    echo

    # read data from patron.txt
    read -p "Enter Patron ID to search: " patronID 
    echo

    readarray -t patronList < patron.txt
    IFS=$'\n'

    counter=0
    for getPatronList in ${patronList[@]}; do
        ((counter++))
    done

    for (( i=0; i<$counter; i++ )); do
        IFS=$'\n'
        for perItem in ${patronList[arrayCounter]}; do              
            IFS=$':'
            read -ra patronDetailsArray <<< $perItem

            if [ ${patronDetailsArray[0]} != $patronID ]; then  
                (( arrayCounter++ ))
            else
                arrayCounter=$arrayCounter
                (( i=3 ))
                # echo "Patron Details:" ${patronDetailsArray[@]}
                break
            fi
        done
    done  

    # display Patron details according patronID
    for i in {1..100}
    do
        printf "_"
    done
    echo

    echo "Full Name:" ${patronDetailsArray[1]}
    echo "Contact Number:" ${patronDetailsArray[2]}
    echo -e "Email Address (As per TAR UMT format):" ${patronDetailsArray[3]} "\n"

    # read "Search Another Person? (y)es or (q)uit :"

    # read "Press (q) to return to University Venue Management Menu."
}

searchPatron

readTextfile() {
    patronID=230812
    # echo read -p "Enter Patron ID to search: " patronID

    readarray -t patronList < patron.txt
    IFS=$'\n'

    counter=0
    for getPatronList in ${patronList[@]}; do
        ((counter++))
    done

    for (( i=0; i<$counter; i++ )); do
        IFS=$'\n'

        for perItem in ${patronList[arrayCounter]}; do              
            IFS=$':'
            read -ra patronDetailsArray <<< $perItem

            if [ ${patronDetailsArray[0]} != $patronID ]; then  
                (( arrayCounter++ ))
            else
                arrayCounter=$arrayCounter
                (( i=3 ))
                echo "Patron Details:" ${patronDetailsArray[@]}
                break
            fi
        done
    done  
}
# textFile