#!/bin/bash
# install fiberdriver

# install needs to be run as root
if [ $(id -u) != "0" ]; then
	echo "Fiberdriver must be installed as root" 1>&2
	exit 1
fi

# alert the user that a program was not found and exit
function software_not_found {
	echo "Could not find required program ${1}" 1>&2
	echo "Please make sure it is installed and check your PATH" 1>&2
	exit 2
}

# ask the user to confirm something
function confirm {
	while read answer; do
		case $answer in
			YES|YEs|YeS|Yes|yES|yEs|yeS|yes|Y|y ) return 0 ;;
			NO|No|nO|no|N|n ) return 1 ;;
			* ) echo -n "Please enter yes or no: " ;;
		esac
	done
}

# make sure we have required software for installation
hash cat 2>/dev/null || software_not_found "cat"
hash grep 2>/dev/null || software_not_found "grep"
hash awk 2>/dev/null || software_not_found "awk"

# error if the os-release doesn't exist
[ -f /etc/os-release ] || { echo "Could not find OS information" 1>&2; exit 3; }

# let's get the OS information and ask the user if it looks correct
OS=$(cat /etc/os-release | grep '^PRETTY_NAME' | awk -F= '{ print $2 }')
echo -n "You appear to be using ${OS}. Is this correct? "
confirm || { echo "Installation aborted."; exit 1; }