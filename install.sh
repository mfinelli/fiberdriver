#!/bin/bash

#  Fiberdriver - the open source server management system
#
#  install.sh
#
#  Copyright 2013 Mario Finelli
#
#  This file is part of Fiberdriver.
#
#  Fiberdriver is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  Fiberdriver is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Fiberdriver.  If not, see <http://www.gnu.org/licenses/>.

# alert user of license
echo "Fiberdriver Copyright (C) 2013 Mario Finelli"
echo "This program comes with ABSOLUTELY NO WARRANTY;"
echo "for details please visit https://gnu.org/licenses/gpl.txt"
echo ""

# get command line options
DEPLOYONLY=false
while [ "$1" ]; do
	case "$1" in
		-D | --deploy-only ) DEPLOYONLY=true; shift ;;
		* ) break ;;
	esac
done

# install needs to be run as root
if [[ $(id -u) != "0" ]]; then
	echo "Fiberdriver must be installed as root." 1>&2
	exit 1
fi

# package managers (@see line 95 if these options change)
declare -A managers
managers[/etc/redhat-release]=yum
managers[/etc/arch-release]=pacman
#managers[/etc/gentoo-release]=emerge
managers[/etc/SuSE-release]=zypper
managers[/etc/debian_version]=apt-get

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
[[ -f /etc/os-release ]] || { echo "Could not find OS information" 1>&2; exit 3; }

# let's get the OS information and ask the user if it looks correct
OS=$(cat /etc/os-release | grep '^PRETTY_NAME' | awk -F= '{ print $2 }')
echo -n "You appear to be using ${OS}. Is this correct? "
confirm || { echo "Installation aborted."; exit 4; }

# probe for the package manager and ask the user if it's right
for manager in "${!managers[@]}"
do
	if [[ -f $manager ]]; then
		MANAGER=${managers[$manager]}
		continue
	fi
done

# make sure we can find the package manager
# TODO: add ability to manually specify package manager
if hash $MANAGER 2>/dev/null; then
	echo -n "Your package manager seems to be ${MANAGER}. Is this correct? "
	confirm || { echo "Installation aborted."; exit 5; }
else
	echo "Could not determine your package manager."
	exit 5;
fi

# get the install command from the package manager
case $MANAGER in
	yum|apt-get ) INSTALL="${MANAGER} -y install" ;;
	pacman ) INSTALL="pacman -S --noconfirm" ;;
#	emerge ) INSTALL="emerge" ;;
	zypper ) INSTALL="zypper install" ;;
	* ) echo "Unidentifed error"; exit 6; ;;
esac

# make sure the user wants to install
echo -n "This will install Fiberdriver on your system. Continue? "
confirm || { echo "Installation aborted."; exit 7; }

# install php and php-fpm
case $MANAGER in
	apt-get|zypper ) PHP="php5 php5-fpm" ;;
	yum|pacman ) PHP="php php-fpm" ;;
	* ) echo "Unidentified error"; exit 6; ;;
esac

# skip install if we're only deploying
if [[ $DEPLOYONLY != true ]]; then

	# install software
	$INSTALL nginx $PHP ruby openssl

	# install gems
	if [[ "$(gem list -i compass)" = "true" ]]; then
		gem update compass
	else
		gem install compass --no-rdoc --no-ri
	fi

fi

# on Arch Linux the gems are not added to PATH
# if our package manager is pacman then we'll add it ourselves
if [[ $MANAGER = "pacman" ]]; then
	GEMPATH="/root/.gem/ruby/2.0.0/bin"
	if [[ ! $PATH =~ (^|:)$GEMPATH(:|$) ]]; then
		PATH+=:$GEMPATH
	fi
fi

INSTALLTO=/var/local/fiberdriver
# create the fiberdriver serve directory
mkdir -p $INSTALLTO

# get the directory installing from
unset CDPATH
SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE" ]]; do
	THISDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$THISDIR/$SOURCE"
done
THISDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# create directories if missing
mkdir -p $INSTALLTO/js $INSTALLTO/sass $INSTALLTO/css $INSTALLTO/sass/foundation/components $INSTALLTO/include/yaml/Exception

# copy fiberdriver files to the install directory
cp "${THISDIR}/web/config.rb" $INSTALLTO/config.rb
# copy javascript
cp "${THISDIR}/web/foundation/js/vendor/custom.modernizr.js" $INSTALLTO/js/custom.modernizr.js
cp "${THISDIR}/web/foundation/js/vendor/jquery.js" $INSTALLTO/js/jquery.js
cp "${THISDIR}"/web/foundation/js/foundation/foundation*.js $INSTALLTO/js/
# copy scss
cp "${THISDIR}/web/fiberdriver.scss" $INSTALLTO/sass/fiberdriver.scss
cp "${THISDIR}/web/foundation/scss/normalize.scss" $INSTALLTO/sass/normalize.scss
cp "${THISDIR}/web/foundation/scss/foundation.scss" $INSTALLTO/sass/foundation.scss
cp "${THISDIR}/web/foundation/scss/foundation/_variables.scss" $INSTALLTO/sass/foundation/_variables.scss
cp "${THISDIR}"/web/foundation/scss/foundation/components/*.scss $INSTALLTO/sass/foundation/components/
# copy web files
cp "${THISDIR}"/web/index.php $INSTALLTO/
cp "${THISDIR}"/web/template.php $INSTALLTO/include/
# copy yaml parser
cp "${THISDIR}"/web/yaml/Dumper.php $INSTALLTO/include/yaml/
cp "${THISDIR}"/web/yaml/Escaper.php $INSTALLTO/include/yaml/
cp "${THISDIR}"/web/yaml/Inline.php $INSTALLTO/include/yaml/
cp "${THISDIR}"/web/yaml/Parser.php $INSTALLTO/include/yaml/
cp "${THISDIR}"/web/yaml/Unescaper.php $INSTALLTO/include/yaml/
cp "${THISDIR}"/web/yaml/Yaml.php $INSTALLTO/include/yaml/
cp "${THISDIR}"/web/yaml/Exception/* $INSTALLTO/include/yaml/Exception/

# compile the scss into css
compass compile /var/local/fiberdriver

# skip new key creation if we're only deploying
if [[ $DEPLOYONLY != true ]]; then

	# create a self-signed ssl certificate (we use this for encryption only)
	mkdir -p /etc/fiberdriver/ssl
	# create a 128 character password from urandom stripping out non alpa-numerics
	password=$(tr -dc A-Za-z0-9_- < /dev/urandom | head -c 128; echo;)
	echo -n "${password}" | openssl genrsa -des3 -out /etc/fiberdriver/ssl/fiberdriver.key -passout stdin 2048
	# create a certificate signing request
	#subj='/C=./ST=./L=./O=./OU=./CN=fiberdriver/emailAddress=./'
	subj="/CN=fiberdriver"
	echo -n "${password}" | openssl req -new -batch -subj "${subj}" -key /etc/fiberdriver/ssl/fiberdriver.key -passin stdin -out /etc/fiberdriver/ssl/fiberdriver.csr
	# remove the password from the key so we don't have to enter it every time
	cp /etc/fiberdriver/ssl/fiberdriver.key /etc/fiberdriver/ssl/fiberdriver.key.pass
	echo -n "${password}" | openssl rsa -in /etc/fiberdriver/ssl/fiberdriver.key.pass -out /etc/fiberdriver/ssl/fiberdriver.key -passin stdin
	# self-sign a certificate
	openssl x509 -req -days 365 -in /etc/fiberdriver/ssl/fiberdriver.csr -signkey /etc/fiberdriver/ssl/fiberdriver.key -out /etc/fiberdriver/ssl/fiberdriver.crt

fi

# backup the original nginx.conf and php.ini (if there are not already backups)
if [[ ! -f /etc/nginx/nginx.conf.org ]]; then
	cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
fi
if [[ ! -f /etc/php/php.ini.org ]]; then
	cp /etc/php/php.ini /etc/php/php.ini.org
fi

# set permissions for fiberdriver files
chmod -R 751 /var/local/fiberdriver
chown -R http:http /var/local/fiberdriver

# copy config files and start the nginx server
case "${OS}" in
	*"Arch Linux"* )
		cp "${THISDIR}"/config/nginx.conf /etc/nginx/nginx.conf
		cp "${THISDIR}"/config/arch.nginx.conf /etc/fiberdriver/nginx.conf
		cp "${THISDIR}"/config/php.ini /etc/php/php.ini
		if [[ $(systemctl is-active nginx) == "active" ]]; then
			systemctl stop nginx
		fi
		if [[ $(systemctl is-enabled nginx) == "disabled" ]]; then
			systemctl enable nginx
		fi
		systemctl start nginx
		if [[ $(systemctl is-active php-fpm) == "active" ]]; then
			systemctl stop php-fpm
		fi
		if [[ $(systemctl is-enabled php-fpm) == "disabled" ]]; then
			systemctl enable php-fpm
		fi
		systemctl start php-fpm
		;;
	* ) echo "Unidentifed error"; exit 6; ;;
esac