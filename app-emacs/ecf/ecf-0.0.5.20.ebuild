# Copyright 1999-2014 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit elisp-common

DESCRIPTION="Emacs Configuration Framework"
HOMEPAGE="http://ecf.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

RESTRICT=nomirror

IUSE="${IUSE}"

DEPEND="virtual/emacs"

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

	dodir /etc/emacs
	dosym ${SITELISPROOT}/rc.d/site-start.el /etc/emacs/site-start.el
    
	cd ${S}
	dodoc doc/*
	
	find ${D}/${SITELISPROOT} -type d -printf "%p/.keep\n" | tr "\n" "\0" | xargs -0 -n100 touch
}

# Local Variables:
# mode: sh
# End:
