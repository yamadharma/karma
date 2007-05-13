# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

ESVN_PROJECT=etoile

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gna.org/svn/etoile/trunk/Etoile"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/etoile"

S1=${S}/Services/Private/AZBackground

DESCRIPTION="AZBackground set an image as background for Etoile."
HOMEPAGE="http://www.etoile-project.org"
#SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	gnustep-libs/xwindowserverkit
	|| ( ( 	x11-libs/libXt
		)
		virtual/x11
	)"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/xwindowserverkit
	|| ( ( 	x11-libs/libXt
		)
		virtual/x11
	)"

egnustep_install_domain "System"

src_compile() {
	cd ${S1}
	gnustep_src_compile
}

src_install() {
	cd ${S1}
	gnustep_src_install
}

