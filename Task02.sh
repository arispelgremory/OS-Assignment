# Register Patron
registerPatron() {
    # patronList = patron.txt

    echo "Patron Registration"
    echo "==================="

    read -p "Patron ID (As per TAR UMT format): " patronID
    read -p "Patron Full Name (As per NRIC): " patronName
    read -p "Contact Number: " contactNumber
    read -p "Email Address (As per TAR UMT format): " email
    echo -e "$patronID:$patronName:$contactNumber:$email" >> ".\patron.txt"
    echo

    read -p "Register Another Patron? (y)es or (q)uit: " newRegistration
    echo

    echo "Press (q) to return to University Venue Management Menu." 
    read mainMenu
}

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

# Search Patron
searchPatron() {
    # Pre_ifs="$IFS"          
    # IFS=":"
    # for Per in $Persons
    # do
    #     echo  The name of Persons are $Per
    # done


    centerAlign "Search Patron Details"
    centerAlign "_____________________"
    echo

    read -p "Enter Patron ID:" readID
    echo

    # IFS=":" read -ra patronDetailsArray < patron.txt

    for i in {1..100}
    do
        printf "_"
    done
    echo

    echo "Full Name: " $patronName
    echo "Contact Number: " $contactNumber
    echo "Email Address (As per TAR UMT format) :"
    echo

    echo "Search Another Person? (y)es or (q)uit :"
    echo

    echo "Press (q) to return to University Venue Management Menu."
}

IFSTesting() {
    Persons=Alex:Thomas:Kyle:Jenny
    Pre_ifs="$IFS"          
    IFS=":"
    for Per in $Persons
    do
        echo The name of Persons are $Per
    done
}

textFile() {
    patronID="1234"

    readarray -t patronList < patron.txt
    IFS=$'\n'

    check=false
    patronDetailsArray=()

    counter=0
    for getPatronList in ${patronList[@]}; do
        ((counter++))
    done

    arrayCounter=0
    
    # while [ $check==false ]; do
            # for getPatronList in ${patronList[counter]}; do
            for (( i=1; i<=$counter; i++ )); do
                echo $i
                for perItem in ${patronList[arrayCounter]}; do
                    IFS=$':'

                    read -ra patronDetailsArray <<< $perItem
                    echo "This is the ID: " ${patronDetailsArray[0]}
                    echo "perItem: "$perItem
                    echo "Whole List: "${patronList[arrayCounter]}

                    if [ ${patronDetailsArray[0]}==$patronID ]; then
                        unset patronDetailsArray
                        ((arrayCounter++))
                        echo "patronID:" $patronID
                        echo "arrayCounter:" $arrayCounter
                        echo "false"
                        echo

                        # if [ $i==3 ]; then
                        #     check=true
                        #     echo "error"
                        # fi
                    else

                        (( i=3 ))
                        check=true
                        echo "true"
                        echo
                    fi
                done
            done  
    # done 
}
textFile