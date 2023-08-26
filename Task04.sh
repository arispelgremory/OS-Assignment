#!/bin/bash

# Validation for venue condition
BookingVenueCondition() {
    read -p "Press (s) to save and generate the venue booking details or Press (c) to cancel the Venue Booking and return to University Venue Management Menu:" newBooking

    case $newBooking in
        "s"|"S")
            echo "Venue Book Successfully!"
            echo "$patronID:$bookingDate:$timeDurationFrom:$timeDurationTo:$reasons" >> "./booking.txt"
            ;;
        "c"|"C")
            echo "Venue Booking Cencelled."
            echo "Returning to Main Menu."
            ;;
        *)
            echo "Please provide a valid choice!" 
            BookingVenueCondition
            ;;
    esac
}

# Booking Venue
BookingVenue() {
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

    BookingVenueCondition
    # echo "$patronID:$bookingDate:$timeDurationFrom:$timeDurationTo:$reasons" >> "./booking.txt"
}

# Validation for patron details condition
patronDetailsCondition() {
    read -p "Press (n) to proceed Book Venue or (q) to return to University Venue Management Menu:" proceedBooking 

    case $proceedBooking in
        "n"|"n")
            BookingVenue
            ;;
        "q"|"Q")
            echo "Returning to Main Menu."
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