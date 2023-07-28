#!/bin/bash
# echo "What is your name?" // print
# read PERSON // read

bold=$(tput bold)
normal=$(tput sgr0)


echo "${bold}University Venue Management Menu${normal}\n" 
echo "A – Register New Patron\nB – Search Patron Details\nC – Add New Venue\nD – List Venue\nE – Book Venue"
echo "\nQ – Exit from Program"

echo "\nPlease select a choice: "
read choice

echo You have selected ${choice}


case $choice | tr '[a-z]' '[A-Z]' in 
    "A")
        echo "Register New Patron"
        ;;
    "B")
        echo "Search Patron Details"
        ;;
    "C")
        echo "Add New Venue"
        ;;
    "D")
        echo "List Venue"
        ;;
    "E")
        echo "Book Venue"
        ;;
    "Q")
        echo "Exit from Program"
        ;;
    *)
        echo "Invalid Choice"
        ;;
esac