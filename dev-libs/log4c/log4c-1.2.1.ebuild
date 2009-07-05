# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

KEYWORDS="amd64 ppc s390 x86"

DESCRIPTION="Library of C++ classes for flexible logging to files, syslog and other destinations."
HOMEPAGE="http://log4c.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_compile() {
	econf \
		$(use_enable doc doxygen) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
