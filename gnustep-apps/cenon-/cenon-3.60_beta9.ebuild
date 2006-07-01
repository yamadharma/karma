# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/pantomime/pantomime-1.1.0.ebuild,v 1.2 2003/08/21 08:54:56 g2boojum Exp $

inherit gnustep-app-gui

IUSE="${IUSE}"

MY_PN=Cenon
MY_PV=${PV/_beta/b}
MY_P=${MY_PN}-${MY_PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="Modular Design and Publishing Software"
HOMEPAGE="http://www.cenon.info/"
SRC_URI="http://www.vhf-group.com/vhfInterservice/download/source/${MY_P}.tar.bz2"
LICENSE="vhfPL"
KEYWORDS="x86 ~ppc"
SLOT="0"

PDEPEND="media-gfx/cenonlibrary"
	
mydoc="INSTALL NEWS LICENSE README"	

src_unpack ()
{
    gnustep-app-gui_src_unpack
    
    cd ${S}
    sed -i -e "/chmod.*Library.*/d" GNUmakefile.postamble
    
    # Change library location
    sed -i -e "s:/usr/GNUstep/Local/Library/Cenon:${GNUSTEP_SYSTEM_ROOT}/Library/Cenon:g" locations.h
}

# Local Variables:
# mode: sh
# End:

