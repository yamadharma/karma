# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${PN}${PV//./}

DESCRIPTION="MGRX is a 2D graphics library derived from the GRX library."
HOMEPAGE="http://mgrx.fgrim.com/"
SRC_URI="http://www.fgrim.com/mgrx/zfiles/${MY_P}.tar.gz"

S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa amd64 ~ppc64 ~ia64"
IUSE="X"
#USE="X sdl"


src_compile() {
	local myconf=""

	sed -i -e "s:INCLUDE_SHARED_SUPPORT=n:INCLUDE_SHARED_SUPPORT=y:g" makedefs.grx

	use amd64 && sed -i -e "s:BUILD_X86_64=n:BUILD_X86_64=y:g" makedefs.grx
#	use X && myconf="${myconf} --target=X11"
	myconf="${myconf} --enable-jpeg --enable-png --enable-zlib --enable-png-z --enable-tiff --enable-bmp --enable-print"
	myconf="${myconf} --enable-bgi --enable-shared"
	
	myconf="${myconf} --with-fontpath=/usr/share/fonts/grx"
	
#	./configure --prefix=/usr ${myconf} || die
	
	use X && make -f makefile.x11 || die
#	use sdl && make -C src -f makefile.sdl || die
}

src_install() {
	use X && make install install-bin INSTALLDIR=${D}/usr -f makefile.x11 || die
#	use sdl && make install install-bin -C src -f makefile.sdl INSTALLDIR=${D}/usr || die
	
	make install-fonts MGRX_DEFAULT_FONT_PATH=${D}/usr/share/fonts/grx -f makefile.x11 || die
#	make install-info INSTALLDIR=${D}/usr -f makefile.x11 || die

}
