# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit eutils

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
SRC_URI="http://developer.kde.org/~wheeler/files/src/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 mips"
IUSE="debug rcc"

DEPEND="sys-libs/zlib 
	rcc? ( app-i18n/librcc )"

src_unpack() {
	unpack ${A}
	cd ${S}
	use rcc && (epatch ${FILESDIR}/taglib-ds-rcc.patch || die)

	aclocal || die
	automake || die
	autoconf || die
}



src_compile() {
	econf $(use_enable debug) || die
	emake || die
	emake -C examples || die
}

src_install() {
	make DESTDIR=${D} install || die
	make -C examples DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README TODO
}
