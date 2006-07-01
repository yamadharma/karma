# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep


MY_PN=MPDCon
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="MPDCon is a simple GNUstep controller for MPD"
HOMEPAGE="http://www.stud.uni-hannover.de/user/64568/MPDCon/MPDCon.html"
SRC_URI="http://www.stud.uni-hannover.de/user/64568/MPDCon/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="${IUSE}"

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}
	||( media-sound/mpd media-sound/mpd-svn )"

egnustep_install_domain "System"

# Local Variables:
# mode: sh
# End:

