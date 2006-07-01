# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app

IUSE="${IUSE}"

S=${WORKDIR}/${P}

DESCRIPTION="A little application that shows the time of the day with an analog
 display. It acts as a dockapp when used with GNUstep."
HOMEPAGE="http://www.linuks.mine.nu/aclock/"
LICENSE="GPL-2"
SRC_URI="http://www.linuks.mine.nu/aclock/${P}.tar.gz"
KEYWORDS="x86 ~ppc"
SLOT="0"

	
mydoc="README ChangeLog"	

# Local Variables:
# mode: sh
# End:

