#!/bin/bash

# Validation for venue condition
venueCondition() {
    read newRegistration 

    case $newRegistration in
        "y"|"Y")
            echo
            registerPatron
            ;;
        "q"|"Q")
            echo "Main Menu"
            ;;
        *)
            echo "Please provide a valid choice" 
            registerCondition
            ;;
    esac
}

# Patron Details Validation
patronDetailsValidation() {
    echo "Patron Details Validation"
    echo "==========================="

    read -p "Please enter Patron's ID Number: " patronID

    if [ ! -f patron.txt ]; then
        echo "Error: patron.txt file does not exist in the current directory."
        return
    fi

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
    read -p "Press (n) to proceed Book Venue or (q) to return to University Venue Management Menu:" 

    # venueCondition
}

bookingVenue() {
    echo "Booking Venue"
    echo "================"

    read -p "Please enter the Room Number: " roomNumber
    echo 

    echo "Room Type:" $labType
    echo "Capacity:" $capacity
    echo "Remarks:" $remarks
    echo "Status:" $status
    echo

    echo "Notes: The booking hours shall be from 8am to 8pm only. The booking duration shall be at least 30 minuts per booking."

    echo "Please enter the following details:"
    echo

    read -p "Booking Date (mm/dd/yy): " bookingDate
    read -p "Time From (hh:mm): " timeDurationFrom
    read -p "Time to (hh:mm): " timeDurationTo
    read -p "Reasons for Booking: " reasons

    echo "Press (s) to save and generate the venue booking details or Press (c) to cancel the Venue Booking and return to University Venue Management Menu:"
    echo "$patronID:$bookingDate:$timeDurationFrom:$timeDurationTo:$reasons" >> "./booking.txt"
}