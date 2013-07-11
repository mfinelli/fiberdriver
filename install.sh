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

# make sure we have required software for installation
hash cat 2>/dev/null || software_not_found "cat"
hash grep 2>/dev/null || software_not_found "grep"
hash awk 2>/dev/null || software_not_found "awk"
