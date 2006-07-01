# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

IUSE="${IUSE}"

MY_PN=${PN/z/Z}
MY_PV=${PV}
MY_P=${MY_PN}-${MY_PV}
S=${WORKDIR}/${MY_PN}

DESCRIPTION="Winzip's-like tool for inspecting the contents of a compressed archive and for extracting."
HOMEPAGE="http://xanthippe.dyndns.org/Zipper/"
SRC_URI="http://xanthippe.dyndns.org/Zipper/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="${GS_DEPEND}
	gnustep-libs/renaissance
	"
	
RDEPEND="${GS_RDEPEND}
	app-arch/tar
	app-arch/bzip2
	app-arch/gzip
	app-arch/rar
	app-arch/lha
	app-arch/unzip"

# Local Variables:
# mode: sh
# End:
