# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/Azalea"

DESCRIPTION="A window manager for GNUstep based on OpenBox 3"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND="gnustep-libs/xwindowserverkit"
RDEPEND="${DEPEND}"

src_install() {
	gnustep-base_src_install
	
	insinto	/usr/share/xsessions
	doins ${FILESDIR}/azalea.desktop
	
	dobin ${FILESDIR}/azalea
}
