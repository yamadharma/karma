# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Draws fireworks and zooming, fading flares"
HOMEPAGE="http://www.cosmosx.org/"
XSCREENSAVER_P="xscreensaver-5.00"
SRC_URI="http://www.cosmosx.org/${P}.tgz
	http://www.jwz.org/xscreensaver/${XSCREENSAVER_P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="|| ( 
		(
			x11-libs/libX11
			x11-libs/libXmu
			x11-libs/libXpm
		)
		virtual/x11
	)"
RDEPEND="${DEPEND}
	x11-misc/xscreensaver"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/${P}-force-compile.patch
	epatch ${FILESDIR}/${P}-xscreensaver-5-api.patch
}

src_compile() {
	cd ${WORKDIR}/${XSCREENSAVER_P}
	econf \
		--with-hackdir=/usr/lib/misc/xscreensaver \
		--with-configdir=/usr/share/xscreensaver/config \
		--x-libraries=/usr/$(get_libdir) \
		--x-includes=/usr/include \
		--with-mit-ext \
		--with-dpms-ext \
		--with-xf86vmode-ext \
		--with-xf86gamma-ext \
		--with-proc-interrupts \
		--with-xpm \
		--with-xshm-ext \
		--with-xdbe-ext \
		--enable-locking \
		|| die "econf failed"
	emake -C utils || die "emake failed"
	emake -C hacks screenhack.o || die "emake failed"
	cd ${S}
	emake xscreensaverdir=${WORKDIR}/${XSCREENSAVER_P} || die "emake failed"
}

src_install() {
	dodir /usr/lib/misc/xscreensaver
	make install targetdir=${D}/usr/lib/misc/xscreensaver \
		|| die "make install failed"
	dodoc README TODO
}
