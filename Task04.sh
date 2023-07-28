#!/bin/bash

# Patron Details Validation
patronDetailsValidation() {
    echo "Patron Details Validation"
    echo "==========================="

    read -p "Please enter Patron's ID Number: " patronID
    echo
    grep $patronID patron.txt

    IFS=$':'
    echo "Testing:" $patronID
    for perItem in ${patronID[0]}; do              

        read -ra patronDetailsArray <<< $perItem
        echo "Patron Name:" ${patronDetailsArray[@]}
    done

    

    # echo "Patron Name (auto display):" $patronName
    # echo

    # read -p "Contact Number: " contactNumber
    # read -p "Email Address (As per TAR UMT format): " email
    # echo -e "$patronID:$patronName:$contactNumber:$email" >> "./patron.txt"
    # echo

    # echo -e "Register Another Patron? (y)es or (q)uit: \n" 
    # echo "Press (q) to return to University Venue Management Menu." 
    
}

patronDetailsValidation

# # Patron Details Validation
# patronDetailsValidation() {
#     # patronList = patron.txt
#     echo
#     echo "Patron Details Validation"
#     echo "==========================="

#     read -p "Patron ID (As per TAR UMT format): " patronID
#     read -p "Patron Full Name (As per NRIC): " patronName
#     read -p "Contact Number: " contactNumber
#     read -p "Email Address (As per TAR UMT format): " email
#     echo -e "$patronID:$patronName:$contactNumber:$email" >> "./patron.txt"
#     echo

#     echo -e "Register Another Patron? (y)es or (q)uit: \n" 
#     echo "Press (q) to return to University Venue Management Menu." 
    
#     registerCondition
# }