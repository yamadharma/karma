# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/gnumail/gnumail-1.1.0.ebuild,v 1.2 2003/10/18 20:14:45 raker Exp $

inherit gnustep-app-gui

IUSE="${IUSE}"

MY_PN=LuserNET
MY_PV=${PV/_/}
MY_P=${MY_PN}-${MY_PV}

S=${WORKDIR}/${MY_P}


DESCRIPTION="GNUstep newsreader"
HOMEPAGE="http://w1.423.telia.com/~u42308495/alex/LuserNET/LuserNET.html"
# SRC_URI="http://w1.423.telia.com/~u42308495/alex/LuserNET/${MY_P}.tar.gz"
SRC_URI="http://w1.423.telia.com/~u42308495/alex/${MY_P}.tar.gz"

DEPEND="${DEPEND}
	gnustep-libs/pantomime"

RDEPEND="${RDEPEND}"

KEYWORDS="x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

mydoc="Changes README"


# Local Variables:
# mode: sh
# End:
