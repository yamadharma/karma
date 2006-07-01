# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

S=${WORKDIR}/MplayerGS

DESCRIPTION="MPlayer is a GNUstep port of MPlayerOSX"
HOMEPAGE="ftp://ftp.gnustep.org/pub/gnustep/usr-apps/"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/usr-apps/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

RDEPEND="${RDEPEND}
	media-video/mplayer"

IUSE="${IUSE}"

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}
	media-video/mplayer"

egnustep_install_domain "System"

src_unpack ()
{
    unpack ${A}
    
    # Fix mplayer location
    cd ${S}
    sed -i -e "s:/usr/local/bin/mplayer:/usr/bin/mplayer:g" MplayerInterface.m
    sed -i -e "s:/usr/local/bin/mplayer:/usr/bin/mplayer:g" PlayerCtrllr.m
}

# Local Variables:
# mode: sh
# End:

