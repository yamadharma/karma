# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libchipcard/libchipcard-0.9.1-r1.ebuild,v 1.14 2007/04/28 17:59:31 swegener Exp $

DESCRIPTION="Libchipcard is a library for easy access to chip cards via chip card readers (terminals)."
SRC_URI="mirror://sourceforge/libchipcard/${P}.tar.gz"
HOMEPAGE="http://www.libchipcard.de/"

SLOT="1"
LICENSE="GPL-2"
KEYWORDS="x86 alpha ppc sparc amd64"
IUSE="ssl"

DEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"

src_compile() {
	sed -i -e 's:$prefix/etc:/etc:g' \
		-e 's:${prefix}/etc:/etc:g' \
		-e 's:$prefix/var:/var:g' \
		-e 's:${prefix}/var:/var:g' \
		configure

	local myconf
	myconf="--disable-pcsc"
	use ssl || myconf="${myconf} --disable-ssl"
	use ssl || myconf="${myconf} --disable-ssl"
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} chroot_dir=${D} install || die
	rm -r ${D}/var
	doinitd ${FILESDIR}/chipcardd
}
