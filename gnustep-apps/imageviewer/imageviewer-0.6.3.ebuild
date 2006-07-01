# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_P=ImageViewer-${PV}

DESCRIPTION="ImageViewer is a small image viewer"
HOMEPAGE="http://www.nice.ch/~phip/softcorner.html"
SRC_URI="http://www.nice.ch/~phip/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="${IUSE}"

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

S=${WORKDIR}/${MY_P}

