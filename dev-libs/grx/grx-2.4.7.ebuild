# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${PN}${PV//./}

DESCRIPTION="GRX graphics library (Borland grphics compatible)."
HOMEPAGE="http://grx.gnu.de"
SRC_URI="http://grx.gnu.de/download/${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa amd64 ~ppc64 ~ia64"
IUSE="X"
#USE="X sdl"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/fd_xwin.diff
	epatch ${FILESDIR}/mousetst.diff
}

src_compile() {
	local myconf=""
	use amd64 && myconf="${myconf} --enable-x86_64"
#	use X && myconf="${myconf} --target=X11"
	myconf="${myconf} --enable-jpeg --enable-png --enable-zlib --enable-png-z --enable-tiff --enable-bmp --enable-print"
	myconf="${myconf} --enable-bgi --enable-shared"
	
	myconf="${myconf} --with-fontpath=/usr/share/fonts/grx"
	
	./configure --prefix=/usr ${myconf} || die
	
	use X && make -C src -f makefile.x11 || die
#	use sdl && make -C src -f makefile.sdl || die
}

src_install() {
	use X && make install install-bin -C src -f makefile.x11 INSTALLDIR=${D}/usr || die
#	use sdl && make install install-bin -C src -f makefile.sdl INSTALLDIR=${D}/usr || die
	
	make install-fonts GRX_DEFAULT_FONT_PATH=${D}/usr/share/fonts/grx || die
	make install-info -C src -f makefile.x11 INSTALLDIR=${D}/usr || die

}
