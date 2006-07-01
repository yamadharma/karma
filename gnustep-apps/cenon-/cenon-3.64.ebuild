# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=Cenon
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_PN}

LIB_PN=CenonLibrary
LIB_PV=3.60
LIB_SUB_PV=-3
LIB_P=${LIB_PN}-${LIB_PV}${LIB_SUB_PV}

DESCRIPTION="Modular Design and Publishing Software"
HOMEPAGE="http://www.cenon.info/"
SRC_URI="http://www.vhf-group.com/vhfInterservice/download/source/${MY_P}.tar.bz2
	http://www.vhf-group.com/vhfInterservice/download/source/${LIB_P}.tar.bz2"
LICENSE="vhfPL"
KEYWORDS="x86 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

mydoc="INSTALL NEWS LICENSE README"	

src_unpack ()
{
    egnustep_env

    unpack ${MY_P}.tar.bz2
    
    cd ${S}

    # Change library location
    sed -i -e "s:/usr/GNUstep/Local/Library/Cenon:${GNUSTEP_SYSTEM_ROOT}/Library/Cenon:g" locations.h
}

src_install ()
{
    egnustep_env
    
    dodir ${GNUSTEP_SYSTEM_ROOT}/Library
    cd ${D}/${GNUSTEP_SYSTEM_ROOT}/Library
    tar xjvf ${DISTDIR}/${LIB_P}.tar.bz2
    rm ${D}/${GNUSTEP_SYSTEM_ROOT}/Library/Cenon/INSTALL
    
    cd ${S}
    egnustep_install

    rm ${D}/${GNUSTEP_SYSTEM_ROOT}/Library/Cenon/README
    
    dodoc ${mydoc}
}

# Local Variables:
# mode: sh
# End:

