# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Languages/Io"

DESCRIPTION="Io language support in a convenient way for GNUstep developers or users"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Io"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="gnustep-libs/distributedview
	gnustep-libs/steptalk"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Path case problem
	ln -s iovm IoVM
}

src_compile() {
	egnustep_env
	egnustep_make steptalk=yes || die "compilation failed"
}
