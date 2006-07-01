# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=Vindaloo

S=${WORKDIR}/${MY_PN}

DESCRIPTION="An Application for displaying and navigating in PDF documents."

HOMEPAGE="http://gna.org/projects/gsimageapps"
SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	gnustep-libs/popplerkit"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/popplerkit"
	
egnustep_install_domain "System"	

# Local Variables:
# mode: sh
# End:

