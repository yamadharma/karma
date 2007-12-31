# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cernlib

DESCRIPTION="CERN's Physics Analysis Workstation data analysis program"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/paw/index.html"
KEYWORDS="amd64 x86"
DEPEND="x11-libs/xbae"

S=${WORKDIR}/${DEB_PN}_${DEB_PV}.orig

src_unpack() {
	cernlib_unpack

	mv ${DEB_PN}-${DEB_PV}/debian "${S}"/
	rm -rf ${DEB_PN}-${DEB_PV} "${DEB_PN}_${DEB_PV}-${DEB_PR}".diff

	# fix some path stuff and collision for comis.h, already installed by cernlib
	sed -i \
		-e '/comis.h/d' \
		-e "s/g77/${FORTRANC}/g" \
		"${S}"/debian/add-ons/Makefile || die "sed failed"
	cernlib_patch
}

