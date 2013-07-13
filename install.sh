#!/bin/bash
# install fiberdriver

# install needs to be run as root
if [ $(id -u) != "0" ]; then
	echo "Fiberdriver must be installed as root" 1>&2
	exit 1
fi

# package managers (@see line 69 if these options change)
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
[ -f /etc/os-release ] || { echo "Could not find OS information" 1>&2; exit 3; }

# let's get the OS information and ask the user if it looks correct
OS=$(cat /etc/os-release | grep '^PRETTY_NAME' | awk -F= '{ print $2 }')
echo -n "You appear to be using ${OS}. Is this correct? "
confirm || { echo "Installation aborted."; exit 4; }

# probe for the package manager and ask the user if it's right
for manager in "${!managers[@]}"
do
	if [ -f $manager ]; then
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

# install php and php-fpm
case $MANAGER in
	apt-get|zypper ) PHP="php5 php5-fpm" ;;
	yum|pacman ) PHP="php php-fpm" ;;
	* ) echo "Unidentified error"; exit 6; ;;
esac

# install software
$INSTALL nginx $PHP ruby

# install gems
if [ "$(gem list -i compass)" = "true" ]; then
	gem update compass
else
	gem install compass
fi

INSTALLTO=/var/local/fiberdriver
# create the fiberdriver serve directory
mkdir -p $INSTALLTO

# create the compass project
compass create $INSTALLTO --css-dir "css" --javascripts-dir "js"

# get the directory installing from
unset CDPATH
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
	THISDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$THISDIR/$SOURCE"
done
THISDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# create directories if missing
mkdir -p $INSTALLTO/js $INSTALLTO/sass $INSTALLTO/css $INSTALLTO/sass/foundation/components

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

# compile the scss into css
compass compile /var/local/fiberdriver