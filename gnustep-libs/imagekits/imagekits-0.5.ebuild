# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/pantomime/pantomime-1.1.0.ebuild,v 1.2 2003/08/21 08:54:56 g2boojum Exp $

inherit gnustep-app

IUSE="${IUSE}"

MY_PN=ImageKits
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="ImageKits is a collection of frameworks to support the applications of ImageApps."
HOMEPAGE="http://mac.wms-network.de/gnustep/imageapps/imagekits/imagekits.html"
LICENSE="LGPL-2.1"
SRC_URI="http://mac.wms-network.de/gnustep/imageapps/imagekits/${MY_P}.tar.gz"
KEYWORDS="x86 ~ppc"
SLOT="0"


# Local Variables:
# mode: sh
# End:

