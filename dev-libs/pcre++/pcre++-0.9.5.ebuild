# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pcre++/pcre++-0.9.5.ebuild,v 1.6 2006/09/06 01:39:53 gustavoz Exp $

IUSE=""

inherit eutils

DESCRIPTION="A C++ support library for libpcre"
HOMEPAGE="http://www.daemon.de/PCRE"
SRC_URI="ftp://ftp.daemon.de/scip/Apps/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc sparc x86"

DEPEND="dev-libs/libpcre"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-nodoc.patch
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO

	cd ${S}/doc/html
	dohtml -r .

	cd ${S}/doc/man/man3
	doman Pcre.3
}
