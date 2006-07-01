# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

IUSE=""

DESCRIPTION="Linux program for writing Microsoft compatible boot records"
HOMEPAGE="http://ms-sys.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

DEPEND="virtual/linux-sources"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile () 
{
    cd ${S}
    make PREFIX=/usr || die
}

src_install () 
{
    dodir /usr/bin
    dodir /usr/share/man/man1
    
    make install PREFIX=${D}/usr MANDIR=${D}/usr/share/man || die
    
    dodoc CHANGELOG CONTRIBUTORS COPYING README TODO 
}


# Local Variables:
# mode: sh
# End:
