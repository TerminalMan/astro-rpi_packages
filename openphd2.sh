#!/bin/bash

VERSION=2.6.14

BUILDDIR=/tmp/openphd2
OUTPUTDIR=/tmp/output

mkdir $BUILDDIR
mkdir -p $OUTPUTDIR

cd  $BUILDDIR

apt update
apt install -y \
	devscripts libusb-dev libudev-dev libv4l-dev libindi-dev \
	libwxgtk3.2-dev libopencv-dev libeigen3-dev libgtest-dev

apt install -y \
	$OUTPUTDIR/libindi-dev*.deb \
	$OUTPUTDIR/libindi1*.deb \
	$OUTPUTDIR/libindi-data*.deb \
	$OUTPUTDIR/indi-bin*.deb

git clone --depth 1 --branch v$VERSION https://github.com/OpenPHDGuiding/phd2
cd $BUILDDIR/phd2
rm -r .git/ .gitignore
rm -rf extra_frameworks WinLibs *.a

cd $BUILDDIR
tar cvzf phd2_$VERSION.orig.tar.gz phd2

cd $BUILDDIR/phd2
sed -i "1s/(${VERSION})/(${VERSION}-terminalman)/" debian/changelog
debuild -us -uc

cp $BUILDDIR/phd2_*.deb $OUTPUTDIR/



