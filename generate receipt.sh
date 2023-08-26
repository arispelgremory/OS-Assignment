GenerateReceipt() {
    patronID="230812"
    patronName="Tan Mei Lee"
    roomNumber="B001A"
    dateBooking="02/28/2023"
    timeFrom="14:00"
    timeTo="16:00"
    reason="For FYP presentation"

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
    mkdir booking_receipts
    mv $fileName booking_receipts
    
}

GenerateReceipt