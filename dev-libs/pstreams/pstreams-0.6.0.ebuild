# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="POSIX Process Control in C++"
HOMEPAGE="http://pstreams.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa amd64 ~ppc64 ~ia64"
IUSE="doc"

src_compile() {
	true
}

src_install() {
	insinto /usr/include/pstreams
	doins pstream.h
	
	use doc && dodoc AUTHORS COPYING.LIB ChangeLog INSTALL MANIFEST README
}
