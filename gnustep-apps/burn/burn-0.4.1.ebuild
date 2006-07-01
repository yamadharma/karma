# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

S=${WORKDIR}/${PN/b/B}
S1=${S}/Bundles/Cdrdao
S2=${S}/Bundles/MP3ToWav

DESCRIPTION="GNUstep based CD burning program."
HOMEPAGE="http://gsburn.sf.net"
SRC_URI="mirror://sourceforge/gsburn/${P}.tar.gz
	mirror://sourceforge/gsburn/cdrdao-${PV}.tar.gz
	mirror://sourceforge/gsburn/mp3towav-${PV}.tar.gz"

KEYWORDS="x86 amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	gnustep-apps/cdplayer"
RDEPEND="${GS_RDEPEND}
	gnustep-apps/cdplayer
	>=app-cdr/cdrtools-2.01
	>=media-sound/cdparanoia-3.9.8
	>=app-cdr/cdrdao-1.1.8"

egnustep_install_domain "System"

src_unpack () 
{
	unpack ${A}
	
	cd ${WORKDIR}
	mv Cdrdao ${S}/Bundles
	mv MP3ToWav ${S}/Bundles
}

src_compile () 
{
	egnustep_env

	for i in ${S} ${S1} ${S2}
        do
	    cd ${i}
	    egnustep_make
	done	    
}


src_install ()
{
        egnustep_env

	cd ${S}
	egnustep_install
        dodoc BUGS CHANGELOG CREDITS README TODO

        cd ${S1}
	egnustep_install
        dodoc README

	cd ${S2}
        egnustep_install
	dodoc README
}

