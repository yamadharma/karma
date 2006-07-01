# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emacs/auctex/auctex-10.0g.ebuild,v 1.1 2002/11/01 02:52:00 mkennedy Exp $

IUSE="ecf"

inherit elisp-common

DESCRIPTION="Emacs Configuration framework"
HOMEPAGE="http://ecf.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="virtual/emacs
	( app-emacs/tiny-tools )"

S="${WORKDIR}/${P}"

src_compile ()
{
    echo "nothing to compile"
}

src_install() 
{
    USE="ecf"    
    
    make install DESTDIR=${D}
      
    dodir ${SITELISPEMACS}
    dosym ${SITELISPROOT}/rc.d/site-start.el ${SITELISPEMACS}/site-start.el
    dosym ${SITELISPROOT}/rc.d/default.el ${SITELISPEMACS}/default.el
    
    cd ${S}
    dodoc doc/*
}

# Local Variables:
# mode: sh
# End:
