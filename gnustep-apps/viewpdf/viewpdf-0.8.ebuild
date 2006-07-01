# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=ViewPDF
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="An Application for displaying and navigating in PDF documents."
HOMEPAGE="http://mac.wms-network.de/gnustep/imageapps/viewpdf/viewpdf.html"
LICENSE="GPL-2"
# SRC_URI="http://mac.wms-network.de/gnustep/imageapps/viewpdf/${MY_P}.tar.gz"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/usr-apps/${MY_P}.tar.gz"
KEYWORDS="x86 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	gnustep-libs/imagekits"
RDEPEND="${GS_RDEPEND}"
	
mydoc="Documentation/*"	

src_install ()
{
    egnustep_env
    egnustep_install

    dodoc ${mydoc}
}


# Local Variables:
# mode: sh
# End:

