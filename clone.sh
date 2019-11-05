#!/bin/bash
menu(){
	clear
	echo "---------------------------------------"
	echo "---------- Tool copy webiste ----------"
	echo "---------------------------------------"
	echo "1. Copy webiste to webiste at host"
	echo "2. Copy website to another host"
	echo "3. Exit"
}

read_options(){
	local choice
	read -p "Enter choice [ 1-3 ]: " choice
	case $choice in

		1)
			wget -q script.lehait.net/copy.sh && sh copy.sh	
		;;

		2) 
			wget -q script.lehait.net/backup.sh && sh backup.sh
		;;
		3 )  
			exit && rm -f *.sh		
		;;
	esac
}

menu
read_options