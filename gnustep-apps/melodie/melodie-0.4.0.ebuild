# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/User/Melodie"

DESCRIPTION="Melodie is a music player for Etoile"

HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

DEPEND="media-libs/libmp4v2
	gnustep-libs/coreobject
	gnustep-libs/etoile-ui
	gnustep-libs/iconkit
	gnustep-libs/mediakit
	gnustep-libs/scriptkit
	gnustep-libs/smalltalkkit"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/Etoile-${PV}"

	sed -i -e "s/-Werror/& -fgnu89-inline -Wno-unreachable-code/" etoile.make "${S}"/GNUmakefile || die "sed failed"
}
