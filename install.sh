#!/bin/bash
# install fiberdriver

# install needs to be run as root
if [ $(id -u) != "0" ]; then
	echo "Fiberdriver must be installed as root"
	exit 1
fi