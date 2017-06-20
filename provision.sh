#!/usr/bin/env bash
set -eu

usage() {
	echo -e "Usage: $0 [-i]" 1>&2
	echo -e "\t-i Install packages" 1>&2
	exit 1
}

while getopts ":idh" opt; do
	case $opt in
		i)
			INSTALL=true;
			;;
		v)
			VERBOSE=true; set -x
			;;
		*)
			usage
			;;
	esac
done
shift $(($OPTIND - 1))

# Poor man's vagrant detection
if [ "$USER" = "ubuntu" ] || [ "$USER" = "vagrant" ]; then
	# Install packages by default if running in vagrant
	INSTALL=true
fi

if [ ${INSTALL:-} ]; then
	# Install initial packages
	export DEBIAN_FRONTEND=noninteractive
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install -y libncurses5-dev texinfo autogen autoconf2.64 g++ libexpat1-dev flex bison gperf cmake libxml2-dev libtool zlib1g-dev libglib2.0-dev make pkg-config gawk subversion expect git libxml2-utils syslinux xsltproc yasm iasl lynx unzip qemu alsa-base alsa-utils pulseaudio pulseaudio-utils ubuntu-desktop tftpd-hpa

    # Make tftboot dir writeable by everyone to fix sudoless build
    sudo chmod 777 /var/lib/tftpboot
fi

#rm -rf genode/contrib/

git submodule init
git submodule update

tar xfj genode/genode-toolchain-15.05-x86_64.tar.bz2

wget https://nextcloud.os.in.tum.de/s/KVfFOeRXVszFROl/download --no-check-certificate -O libports.tar.bz2
tar xvjC genode/ -f libports.tar.bz2

make ports
