# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/terminal/terminal-0.9.4.ebuild,v 1.2 2003/07/28 04:06:48 raker Exp $

inherit gnustep-app-gui

MY_P=Mplayer-${PV}
S=${WORKDIR}/mplayerPort


DESCRIPTION="MPlayer is a GNUstep port of MPlayerOSX"
HOMEPAGE="http://gnustep-apps.org/fabien/Mplayer"
SRC_URI="http://gnustep-apps.org/fabien/Mplayer/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="${RDEPEND}
	media-video/mplayer"

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

