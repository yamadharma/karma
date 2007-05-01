# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

ESVN_PROJECT=etoile

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gna.org/svn/etoile/trunk/Etoile"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/etoile"

S1=${S}/Services/Private/Azalea

DESCRIPTION="Azalea is a GNUstep window mamager, based on OpenBox3."
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
	)
	virtual/xft
	>=dev-libs/glib-2
	>=media-libs/fontconfig-2
	>=dev-libs/libxml2-2.0
	>=media-libs/freetype-2.0"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/xwindowserverkit
	|| ( ( 	x11-libs/libXt
		)
		virtual/x11
	)
	virtual/xft
	>=dev-libs/glib-2
	>=media-libs/fontconfig-2
	>=dev-libs/libxml2-2.0
	>=media-libs/freetype-2.0"

egnustep_install_domain "System"

src_compile() {
	cd ${S1}
	gnustep_src_compile
}

src_install() {
	cd ${S1}
	gnustep_src_install
}

