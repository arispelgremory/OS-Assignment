#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)

echo -e "${bold}University Venue Management Menu${normal}\n"
echo -e "A – Register New Patron\nB – Search Patron Details\nC – Add New Venue\nD – List Venue\nE – Book Venue"
echo -e "\nQ – Exit from Program\n"
echo -e "Please select a choice: "
read choice

choice=$(echo -e $choice | tr '[a-z]' '[A-Z]')
echo -e "You have selected ${choice}\n"

case $choice in
    "A" | "a")
        echo -e "Register New Patron\n"
        bash Task02.sh;
        ;;
    "B" | "b")
        echo -e "Search Patron Details\n"
        ;;
    "C" | "c")
        echo -e "Add New Venue\n"
        ;;
    "D" | "d")
        echo -e "List Venue\n"
        ;;
    "E" | "e")
        echo -e "Book Venue\n"
        ;;
    "Q" | "q")
        echo -e "Exit from Program\n"
        ;;
    *)
        echo -e "Invalid Choice\n"
        ;;
esac
