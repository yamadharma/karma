# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/terminus-font/terminus-font-4.07.ebuild,v 1.3 2004/06/07 20:56:37 agriffis Exp $

#FONT_SUPPLIER="bitstream"
FONT_BUNDLE="terminus"

inherit fonts

IUSE="${IUSE}"
#IUSE="X"

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://www.is-vn.bg/hamster/jimmy-en.html"
SRC_URI="http://www.is-vn.bg/hamster/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc sparc alpha mips hppa ia64 amd64"


DEPEND="sys-apps/gawk
	dev-lang/perl
	X? ( virtual/x11 )"
RDEPEND="X? ( virtual/x11 )"

FONT_FORMAT="pcf bdf"

src_compile () 
{
    ./configure \
	--prefix=${D}/usr \
	--psfdir=${D}/usr/share/consolefonts \
	--acmdir=${D}/usr/share/consoletrans \
	--unidir=${D}/usr/share/consoletrans \
	--x11dir=${D}/usr/share/fonts/pcf/public/terminus

    make psf txt || die
    
    # If user wants fonts for X11
    if use X 
	then
	make pcf || die
    fi
}

src_install () 
{
    fonts_src_install
    
    cd ${S}
    make install-psf install-acm install-uni install-ref || die
    
    dodoc README*
}

# Local Variables:
# mode: sh
# End:
