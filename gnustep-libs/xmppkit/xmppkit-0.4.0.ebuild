# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/XMPPKit"

DESCRIPTION=" Objective-C implementation of the XMPP protocol"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

DEPEND="gnustep-libs/addresseskit
	gnustep-libs/etoile-foundation"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/Etoile-${PV}"

	sed -i -e "s/-Werror/& -fgnu89-inline/" etoile.make || die "sed failed"
}
