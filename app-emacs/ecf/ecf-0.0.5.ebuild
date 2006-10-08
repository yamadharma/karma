# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

USE="ecf"    

inherit elisp

DESCRIPTION="Emacs Configuration Framework"
HOMEPAGE="http://ecf.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="ecf"

DEPEND="virtual/emacs
	( app-emacs/tiny-tools )"

S="${WORKDIR}/${P}"

src_compile ()
{
        einfo "Nothing to compile"
}

src_install() 
{
	make install DESTDIR=${D}
      
        dodir ${SITELISPEMACS}
	dosym ${SITELISPROOT}/rc.d/site-start.el ${SITELISPEMACS}/site-start.el
	dosym ${SITELISPROOT}/rc.d/default.el ${SITELISPEMACS}/default.el
    
	cd ${S}
	dodoc doc/*
	
	find ${D}/${SITELISPROOT} -type d -printf "%p/.keep\n" | tr "\n" "\0" | xargs -0 -n100 touch
}

# Local Variables:
# mode: sh
# End:
