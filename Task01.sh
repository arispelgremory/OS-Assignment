# echo "What is your name?" // print
# read PERSON // read

bold=$(tput bold)
normal=$(tput sgr0)
echo "${bold}Hello, $PERSON!${normal}" 
