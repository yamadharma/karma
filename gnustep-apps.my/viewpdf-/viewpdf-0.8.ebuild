# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/pantomime/pantomime-1.1.0.ebuild,v 1.2 2003/08/21 08:54:56 g2boojum Exp $

inherit gnustep-app

IUSE="${IUSE}"

MY_PN=ViewPDF
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="An Application for displaying and navigating in PDF documents."
HOMEPAGE="http://mac.wms-network.de/gnustep/imageapps/viewpdf/viewpdf.html"
LICENSE="GPL-2"
SRC_URI="http://mac.wms-network.de/gnustep/imageapps/viewpdf/${MY_P}.tar.gz"
KEYWORDS="x86 ~ppc"
SLOT="0"

DEPEND="${DEPEND}
	gnustep-libs/imagekits"
	
mydoc="Documentation/*"	

# Local Variables:
# mode: sh
# End:

