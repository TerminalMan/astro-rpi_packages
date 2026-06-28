#!/bin/bash

source versions.txt

VERSION=$indi_version
BUILDDIR=/tmp/indi
OUTPUTDIR=/tmp/output

mkdir $BUILDDIR
mkdir -p $OUTPUTDIR

cd $BUILDDIR

apt update
apt install -y \
	git dpkg-dev devscripts equivs \
	cdbs cmake pkgconf libcfitsio-dev \
	libnova-dev libusb-dev zlib1g-dev \
	libjpeg-dev libgsl-dev liberfa-dev \
	libcurl4-gnutls-dev libtheora-dev \
	libogg-dev libfftw3-dev libev-dev \
	librtlsdr-dev libxisf-dev libudev-dev

git clone --depth 1 --branch v$VERSION https://github.com/indilib/indi.git

cd indi
dpkg-buildpackage -us -uc -b

cd $BUILDDIR
cp indi-bin_*deb libindi1_*deb libindi-data_*deb libindi-dev_*deb $OUTPUTDIR

apt install $OUTPUTDIR/indi-bin_*.deb \
			$OUTPUTDIR/libindi1_*deb \
			$OUTPUTDIR/libindi-data_*deb \
			$OUTPUTDIR/libindi-dev_*deb
