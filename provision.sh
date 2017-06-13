#!/usr/bin/env bash
set -ex

# Config
INSTALLBASE=/var/tmp/modelcar
INSTALLDIR=$INSTALLBASE/operating-system
mkdir -p $INSTALLDIR

# Poor man's vagrant detection
if [ "$USER" = "ubuntu" ] || [ "$USER" = "vagrant" ]; then
	VAGRANT=true
fi

if [ ${VAGRANT:-} ]; then
	# Install initial packages
	export DEBIAN_FRONTEND=noninteractive
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install -y libncurses5-dev texinfo autogen autoconf2.64 g++ libexpat1-dev flex bison gperf cmake libxml2-dev libtool zlib1g-dev libglib2.0-dev make pkg-config gawk subversion expect git libxml2-utils syslinux xsltproc yasm iasl lynx unzip qemu alsa-base alsa-utils pulseaudio pulseaudio-utils ubuntu-desktop tftpd-hpa
fi


cd $INSTALLBASE
git clone https://github.com/argos-research/operating-system.git
#rm -rf $INSTALLDIR/genode/contrib/

cd $INSTALLDIR

git submodule init
git submodule update

tar xfj genode/genode-toolchain-15.05-x86_64.tar.bz2

wget https://nextcloud.os.in.tum.de/s/KVfFOeRXVszFROl/download --no-check-certificate -O libports.tar.bz2
tar xvjC genode/ -f libports.tar.bz2

make
