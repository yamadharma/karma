# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://www.is-vn.bg/hamster/jimmy-en.html"
SRC_URI="http://www.is-vn.bg/hamster/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~mips ~hppa ~ia64 amd64 ~ppc64"
IUSE="X"

DEPEND="sys-apps/gawk
	dev-lang/perl
	X? ( || ( x11-apps/bdftopcf virtual/x11 ) )"
RDEPEND=""

FONT_SUFFIX="pcf"

src_compile() {
	./configure \
		--prefix=/usr \
		--psfdir=/usr/share/consolefonts \
		--acmdir=/usr/share/consoletrans \
		--unidir=/usr/share/consoletrans \
		--x11dir=/usr/share/fonts/pcf/public/terminus

	make psf txt || die

	# If user wants fonts for X11
	if use X; then
		make pcf || die
	fi
}

src_install() {
	make DESTDIR=${D} install-psf install-acm install-ref || die

	font_src_install
	
	dodoc README*	
}
