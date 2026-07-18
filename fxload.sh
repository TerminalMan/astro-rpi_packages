#!/bin/bash

source versions.txt
VERSION=$fxload_version

BUILDDIR="/tmp/fxload/"
OUTPUTDIR="/tmp/output/"

mkdir -p $BUILDDIR $OUTPUTDIR

function install_dependencies {
	apt update
	apt install -y make gcc libusb-dev
}

function build_fxload {
	cd ${BUILDDIR}
	git clone https://github.com/lhondareyte/fxload/
	cd fxload
	git checkout $VERSION
	make
}

function build_deb {
	cd ${BUILDDIR}

	mkdir -p debian/fxload/DEBIAN

	install -D -m644 fxload/fxload.8 debian/fxload/usr/share/man/man8/fxload.8
	install -D -m755 fxload/fxload debian/fxload/sbin/fxload
	install -D -m644 fxload/a3load.hex debian/fxload/usr/share/usb/a3load.hex
}

function write_control {
	cd ${BUILDDIR}

	local pkg="fxload"
	local version="$1"
	local arch="${2:-amd64}"
	local maintainer="$3"
	local description="$4"
	local depends="${5:-libc6}"

	cat > debian/fxload/DEBIAN/control <<-EOF
		Package: $pkg
		Version: $version
		Section: utils
		Priority: optional
		Architecture: $arch
		Maintainer: $maintainer
		Depends: $depends
		Description: $description
	EOF
}

function create_deb {
	local version="$1"
	local arch="$2"
	cd ${BUILDDIR}
	dpkg-deb --build debian/fxload fxload_${version}_${arch}.deb
}

sys_arch=$(dpkg --print-architecture)

install_dependencies
build_fxload
build_deb

write_control 	${VERSION} \
		${sys_arch} \
		"terminalman" \
		"Program to download firmware into FX, FX2, FX2LP and FX3 EZ-USB devices"

create_deb 20140224 ${sys_arch}

cp ${BUILDDIR}/fxload_*deb ${OUTPUTDIR}/
