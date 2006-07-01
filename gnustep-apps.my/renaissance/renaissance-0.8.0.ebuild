# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/renaissance/renaissance-0.7.0.ebuild,v 1.1 2003/07/15 08:09:24 raker Exp $

inherit gnustep-app-gui

IUSE="${IUSE}"

S=${WORKDIR}/${P/r/R}

DESCRIPTION="GNUstep xml-based UI toolkit"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="http://www.gnustep.it/Renaissance/Download/${P/r/R}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"

mydoc="ANNOUNCE AUTHORS COPYING.LIB INSTALL INSTALL.OSX NOTES.OSX README TODO"

extradocdir="Documentation"

src_unpack ()
{
    gnustep-app-gui_src_unpack
    
    cd ${S}
    sed -i -e "/DOCUMENT_NAME =.*/a \manual_DOC_INSTALL_DIR=Developer/Renaissance" ${S}/Documentation/GNUmakefile
    sed -i -e "/DOCUMENT_NAME =.*/a \Renaissance_DOC_INSTALL_DIR=Developer/Renaissance" ${S}/Documentation/Tutorials/Renaissance/GNUmakefile
}

src_install ()
{
    gnustep-app-gui_src_install
    
    cd ${S}
    if ( use doc )
	then
	tar cvf Examples.tar Examples
	dodoc Examples.tar
    fi
}

# Local Variables:
# mode: sh
# End:
