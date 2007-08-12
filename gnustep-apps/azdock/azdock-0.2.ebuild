# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/AZDock"

DESCRIPTION="A dock for the Etoile project"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND="gnustep-libs/xwindowserverkit
	gnustep-apps/etoile-system"
RDEPEND="${DEPEND}
	gnustep-apps/azalea"

src_compile() {
	egnustep_env
	egnustep_make etoile=yes || die "compilation failed"
}

DEPEND="gnustep-libs/bookmarkkit"
RDEPEND="${DEPEND}"
