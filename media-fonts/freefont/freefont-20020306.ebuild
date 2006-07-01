# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-fonts/freefonts/freefonts-0.10-r2.ebuild,v 1.4 2003/09/11 01:39:37 msterret Exp $


inherit fonts

IUSE=""

S=${WORKDIR}
DESCRIPTION="Free UCS Outline Fonts"
SRC_URI="http://freesoftware.fsf.org/download/freefont/${PN}-ttf-${PV}.tar.gz"
HOMEPAGE="http://www.nongnu.org/freefont/"
KEYWORDS="x86 ~sparc ~ppc"
SLOT="0"
LICENSE="GPL-2"

FONT_FORMAT="ttf"


# Local Variables:
# mode: sh
# End:
