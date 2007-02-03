# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit nfont

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

	# If user wants fonts for X11
	if use X; then
		make DESTDIR=${D} install-pcf || die
		mkfontdir ${D}/usr/share/fonts/pcf/public/terminus
	fi

	dodoc README*	
	
	if ( use gnustep )
	    then
	    dodir /usr/share/fonts/bdf/public/terminus
	    cp ${S}/*.bdf ${D}/usr/share/fonts/bdf/public/terminus
    	    nfont_src_install
	fi
}

fonts_pkg_postinst () 
{
        if ( use X )
	    then	
    	    chkfontpath -q -a /usr/share/fonts/pcf/public/terminus
	    /etc/init.d/xfs restart
	fi	
	fc-cache
}


fonts_pkg_prerm () 
{
        cd /usr/share/fonts/pcf/public/terminus
        rm -f fonts.cache-1 fonts.list
        if ( use X )
	    then	
	    chkfontpath -r /usr/share/fonts/pcf/public/terminus
	    /etc/init.d/xfs restart
        fi
}
