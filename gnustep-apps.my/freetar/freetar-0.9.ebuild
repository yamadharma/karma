# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app-gui


MY_PN=FreeTar-Port
MY_PV=${PV}
MY_P=${MY_PN}-${MY_PV}
S=${WORKDIR}/FreeTar_1_1_1_Source

DESCRIPTION="GNUstep port of MacOSX FreeTar"
HOMEPAGE="http://www.gnustep-apps.org/fabien/FreeTar"
SRC_URI="http://www.gnustep-apps.org/fabien/FreeTar/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

# Local Variables:
# mode: sh
# End:
