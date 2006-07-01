# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emulation/dosemu/dosemu-1.1.5-r1.ebuild,v 1.4 2003/10/03 07:59:51 vapier Exp $

inherit eutils

P_FD=dosemu-freedos-b8p-bin
DESCRIPTION="DOS Emulator"
HOMEPAGE="http://www.dosemu.org/"
SRC_URI="mirror://sourceforge/dosemu/${P_FD}.tgz
	mirror://sourceforge/dosemu/${P}.tgz"

LICENSE="GPL-2 | LGPL-2.1"
SLOT="0"
KEYWORDS="-* x86"
IUSE="X svga"

DEPEND="X? ( virtual/x11 )
	svga? ( media-libs/svgalib )
	sys-libs/slang"

src_unpack() {
	unpack ${P}.tgz
	epatch ${FILESDIR}/dosemu-broken-links.diff
	# extract freedos binary
	cd ${S}/src
	unpack ${P_FD}.tgz
}

src_compile() {
	local myflags

### mitshm will bork ./base-configure entirely, so we disable it here
	myflags="--enable-mitshm=no"
	myflags="${myflags} --enable-experimental"
	myflags="${myflags} --disable-force-slang"

### and then set build paramaters based on USE variables
	use X || myflags="${myflags} --with-x=no"
	use svga && myflags="${myflags} --enable-use-svgalib"

	econf ${myflags} || die "DOSemu Base Configuration Failed"

### Ok, the build tree is clean, lets make the executables, and 'dos' commands
	emake CFLAGS="${CFLAGS}" -C src || die "DOSemu Make Failed!"
	emake CFLAGS="${CFLAGS}" dosbin || die "DOSbin Make Failed"
}

src_install() {
	make DESTDIR=${D} install || die

	doman man/*.1
	rm -rf ${D}/opt/dosemu/man/

	mv ${D}/usr/share/doc/dosemu ${D}/usr/share/doc/${PF}

	# freedos tarball is needed in /usr/share/dosemu
	cp ${DISTDIR}/${P_FD}.tgz ${D}/usr/share/dosemu/dosemu-freedos-bin.tgz
}
