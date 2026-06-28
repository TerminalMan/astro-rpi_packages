#!/bin/bash

# Script builds and installs the libatik package

source versions.txt

VERSION=$indi_3rdparty_version
BUILDDIR=/tmp/indi-3rdparty
OUTPUTDIR=/tmp/output

mkdir $BUILDDIR
mkdir -p $OUTPUTDIR

cd $BUILDDIR

apt update
apt install -y \
	git libnova-dev libcfitsio-dev \
	libusb-1.0-0-dev zlib1g-dev libgsl-dev \
	build-essential cmake git libjpeg-dev \
	libcurl4-gnutls-dev libtiff-dev libfftw3-dev \
	libftdi-dev libgps-dev libraw-dev libdc1394-dev \
	libgphoto2-dev libboost-dev libboost-regex-dev \
	librtlsdr-dev liblimesuite-dev libftdi1-dev \
	libavcodec-dev libavdevice-dev libzmq3-dev \
	libudev-dev libzmq3-dev 7zip wget

apt install -y \
	$OUTPUTDIR/libindi-dev*.deb \
	$OUTPUTDIR/libindi1*.deb \
	$OUTPUTDIR/libindi-data*.deb \
	$OUTPUTDIR/indi-bin*.deb

cd $BUILDDIR/indi-3rdparty/scripts
bash indi-3rdparty-deb.sh libatik

bash indi-3rdparty-deb.sh indi-atik

cp build/libatik_*deb $OUTPUTDIR

apt install $OUTPUTDIR/libatik_*deb
