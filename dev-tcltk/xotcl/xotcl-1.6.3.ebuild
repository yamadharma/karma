# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI="2"

inherit eutils multilib


DESCRIPTION="MIT Object extension to Tcl"
HOMEPAGE="http://xotcl.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/tcl-8.4.5
        >=dev-lang/tk-8.4.5"


src_configure() {
	local myconf

	myconf+=" --with-xotclsh --with-xwish"
	econf ${myconf} || die
}

src_install() {
	make install DESTDIR=${D}
	# Hack
	rm ${D}/usr/$(get_libdir)/*.so
	dosym /usr/$(get_libdir)/xotcl${PV}/libxotcl${PV}.so /usr/$(get_libdir)/libxotcl${PV}.so

	doman man/*.1
	dodoc ChangeLog* README* COMPILE* COPYRIGHT


	docinto doc
	dohtml -r doc
}

src_test() {
	make test
}
