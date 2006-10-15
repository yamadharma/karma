# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=ViewPDF
S=${WORKDIR}/${MY_PN}

DESCRIPTION="An Application for displaying and navigating in PDF documents."

# HOMEPAGE="http://mac.wms-network.de/gnustep/imageapps/viewpdf/viewpdf.html"
# SRC_URI="http://mac.wms-network.de/gnustep/imageapps/viewpdf/${MY_P}.tar.gz"

HOMEPAGE="http://gna.org/projects/gsimageapps"
SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	gnustep-libs/pdfkit"
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

