# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV=jun2008
MY_P=${PN}_${MY_PV}_redist

DESCRIPTION="A remote security scanner for Linux"
HOMEPAGE="http://www.microsoft.com"
SRC_URI="${MY_P}.exe"
RESTRICT="fetch strip"

LICENSE="EULA"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="app-arch/p7zip
	app-arch/cabextract"

PDEPEND=""

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please download ${MY_P}.exe from http://filehippo.com/download_directx/"
	einfo "The file should then be placed into ${DISTDIR}."
}

src_unpack() {
	cd ${WORKDIR}
	7z x ${DISTDIR}/${MY_P}.exe
	mkdir x86
	mkdir x64

	for i in *x86*.cab
	do
	    mv $i x86
	done

	for i in *x64*.cab
	do
	    mv $i x64
	done
    
	cd ${S}/x86
	for i in *.cab
	do
	    cabextract $i
	done
	
}

src_install() {
	einfo
}

