# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emacs/emacs-w3m/emacs-w3m-1.3.2.ebuild,v 1.3 2003/03/10 23:22:25 mholzer Exp $

inherit elisp

IUSE=""

DESCRIPTION="emacs-w3m is interface program of w3m on Emacs."
HOMEPAGE="http://emacs-w3m.namazu.org"
SRC_URI="http://emacs-w3m.namazu.org/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
        || ( >=net-www/w3m-0.3.1 net-www/w3m-m17n )"
#        >=app-emacs/apel-10.3
#        >=virtual/flim-1.14"


S=${WORKDIR}/${P}

src_compile() 
{
    econf \
	--with-lispdir=${SITELISP}/${PN}
    make
}

src_install () 
{
    emake prefix=${D}/usr \
	lispdir=${D}/${SITELISP}/${PN} \
	infodir=${D}/usr/share/info \
	install install-icons || die

    rm -f ${D}/${SITELISP}/${PN}/ChangeLog*
    
    elisp-site-file-install ${FILESDIR}/70emacs-w3m-gentoo.el

    dodoc ChangeLog* README* TIPS* FAQ*
}
