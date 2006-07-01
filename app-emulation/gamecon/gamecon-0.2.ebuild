# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emulation/game-launcher/game-launcher-0.9.8.ebuild,v 1.4 2003/06/21 08:05:27 vapier Exp $

DESCRIPTION="Act as a central point for your native Linux and Windows games (using wine or wineX)"
HOMEPAGE="http://www.bitmat.co.uk/gamecon"
SRC_URI="http://www.bitmat.co.uk/gamecon/${P}.tar.gz"

S=${WORKDIR}/${P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="virtual/python"

DEPEND="${RDEPEND}"

src_compile() 
{
    echo "Nothing to do"
}

src_install() 
{
    dodir /usr/share/gamecon
    dodir /usr/share/gamecon/userdata
    dodir /usr/share/gamecon/icons

    dobin gamecon
    
    cp gamecon.glade ${D}/usr/share/gamecon
    cp games ${D}/usr/share/gamecon/userdata
    cp *.xpm ${D}/usr/share/gamecon/icons
    
    dodoc BUGS COPYING ChangeLog README
}
