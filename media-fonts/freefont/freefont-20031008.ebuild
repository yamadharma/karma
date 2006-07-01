# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-fonts/freefonts/freefonts-0.10-r2.ebuild,v 1.4 2003/09/11 01:39:37 msterret Exp $


inherit fonts

IUSE="X gnustep"

SUBPV=-1

DESCRIPTION="Free UCS Outline Fonts"
SRC_URI="mirror://debian/pool/main/t/ttf-${PN}/ttf-${PN}_${PV}${SUBPV}.tar.gz"
HOMEPAGE="http://www.nongnu.org/freefont/"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~sparc ~ppc"

S=${WORKDIR}

newdepend	"media-gfx/pfaedit"

FONT_FORMAT="ttf"

S_FONTS=usr/share/fonts/truetype/freefont

mydoc="usr/share/doc/ttf-freefont/*"

#src_unpack ()
#{
#    cd ${WORKDIR}
#    dpkg --extract ${DISTDIR}/${A} .
#}



# Local Variables:
# mode: sh
# End:
