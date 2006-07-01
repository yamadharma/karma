# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=SlideShowKit
MY_PV=${PV/*_pre}

S=${WORKDIR}/${MY_PN}

DESCRIPTION="Small kit to include slideshow in your application"

HOMEPAGE="http://gna.org/projects/gsimageapps"
SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

