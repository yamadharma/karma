# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI="4"


DESCRIPTION="CPN Tools is a tool for editing, simulating, and analyzing Colored Petri nets"
HOMEPAGE="http://cpntools.org/"
SRC_URI="http://cpntools.org/downloads/${PN}_${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}

src_install () {
	dodir /opt
	mv ${S}/CPNTools ${D}/opt
	dobin ${FILESDIR}/cpntools
}

