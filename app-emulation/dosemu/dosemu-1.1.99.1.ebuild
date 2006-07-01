# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emulation/dosemu/dosemu-1.1.99.1.ebuild,v 1.2 2003/10/03 07:59:51 vapier Exp $

inherit eutils

P_FD=dosemu-freedos-b9-bin
DESCRIPTION="DOS Emulator"
HOMEPAGE="http://www.dosemu.org/"
SRC_URI="mirror://sourceforge/dosemu/${P_FD}.tgz
	mirror://sourceforge/dosemu/${P}.tgz"

LICENSE="GPL-2 | LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="X svga"

DEPEND="X? ( virtual/x11 )
	svga? ( media-libs/svgalib )
	sys-libs/slang"

# Has problems with -O3 on some systems
replace-flags -O[3-9] -O2

src_unpack() {
	unpack ${P}.tgz
	# extract freedos binary
	cd ${S}/src
	unpack ${P_FD}.tgz
}

src_compile() {
	local myflags

	use X || myflags="${myflags} --with-x=no"
	use svga && myflags="${myflags} --enable-use-svgalib"

	econf ${myflags} || die "DOSemu Base Configuration Failed"

	emake || die
}

src_install() {
	einstall || die

	doman man/*.1
	rm -rf ${D}/opt/dosemu/man/

	mv ${D}/usr/share/doc/dosemu ${D}/usr/share/doc/${PF}

	# freedos tarball is needed in /usr/share/dosemu
	cp ${DISTDIR}/${P_FD}.tgz ${D}/usr/share/dosemu/dosemu-freedos-bin.tgz
}
