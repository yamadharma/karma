# Copyright 1999-2009 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

EAPI="2"

DESCRIPTION="Linux program for writing Microsoft compatible boot records"
HOMEPAGE="http://ms-sys.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

IUSE="static"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"


src_compile() {
	use static && sed -i -e "s:^EXTRA_LDFLAGS.*$:EXTRA_LDFLAGS = -static:" Makefile
	make PREFIX=/usr || die
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1

	make install PREFIX=${D}/usr MANDIR=${D}/usr/share/man || die
	dodoc CHANGELOG CONTRIBUTORS COPYING README TODO 
}


# Local Variables:
# mode: sh
# End:
