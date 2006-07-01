# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=PDFKit

S=${WORKDIR}/${MY_PN}

DESCRIPTION="ImageKits is a collection of frameworks to support the applications of ImageApps."

# HOMEPAGE="http://mac.wms-network.de/gnustep/imageapps/imagekits/imagekits.html"
# SRC_URI="http://mac.wms-network.de/gnustep/imageapps/imagekits/${MY_PN}-${PV}.tar.gz"

HOMEPAGE="http://gna.org/projects/gsimageapps"
SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

