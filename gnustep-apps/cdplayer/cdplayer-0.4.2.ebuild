# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

S=${WORKDIR}/${PN}

DESCRIPTION="Small CD Audio Player for GNUstep."
HOMEPAGE="http://gsburn.sf.net"
SRC_URI="mirror://sourceforge/gsburn/${P}.tar.gz"

KEYWORDS="x86 amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	>=media-libs/libcdaudio-0.7
	gnustep-apps/preferences
	gnustep-libs/cddb"
RDEPEND="${GS_RDEPEND}
	>=media-libs/libcdaudio-0.7
	gnustep-apps/preferences
	gnustep-libs/cddb"

egnustep_install_domain "System"

src_install ()
{
    gnustep_src_install

    cd ${S}    
    dodir ${GNUSTEP_SYSTEM_ROOT}/Library/Headers/${LIBRARY_COMBO}
    cp -R CDPlayer ${D}/${GNUSTEP_SYSTEM_ROOT}/Library/Headers/${LIBRARY_COMBO}
    
    dodoc CHANGELOG CREDITS ChangeLog README TODO
}

