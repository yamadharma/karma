# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dosemu/dosemu-1.2.2.ebuild,v 1.1 2004/07/31 18:29:44 voxus Exp $

inherit flag-o-matic eutils

P_FD=dosemu-freedos-b9-bin
DESCRIPTION="DOS Emulator"
HOMEPAGE="http://www.dosemu.org/"
SRC_URI="mirror://sourceforge/dosemu/${P_FD}.tgz
	mirror://sourceforge/dosemu/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="X svga gpm"

DEPEND="X? ( virtual/x11 )
	svga? ( media-libs/svgalib )
	gpm? ( sys-libs/gpm )
	sys-libs/slang"

src_unpack() {
	unpack ${P}.tgz
	cd ${S}
	epatch ${FILESDIR}/dosemu-broken-links.diff
	# extract freedos binary
	cd ${S}/src
	unpack ${P_FD}.tgz
}

src_compile() {
	local myflags

	use X || myflags="${myflags} --with-x=no"
	use svga && myflags="${myflags} --enable-use-svgalib"
	use gpm || myflags="${myflags} --without-gpm"

	# Has problems with -O3 on some systems
	replace-flags -O[3-9] -O2

	econf ${myflags} || die "DOSemu Base Configuration Failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	doman man/*.1
	rm -rf ${D}/opt/dosemu/man/

	mv ${D}/usr/share/doc/dosemu ${D}/usr/share/doc/${PF}

	# freedos tarball is needed in /usr/share/dosemu
	cp ${DISTDIR}/${P_FD}.tgz ${D}/usr/share/dosemu/dosemu-freedos-bin.tgz
}
