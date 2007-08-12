# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/${PN/c/C}

DESCRIPTION="Additional themes for GNUstep Camaelon theme engine"

HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Camaelon"
SRC_URI="http://brante.dyndns.org/gnustep/download/MaxCurve-0.2.tar.bz2
	mirror://sourceforge/mpdcon/IndustrialTheme.tar.bz2"
KEYWORDS="x86 ~ppc ~sparc ~alpha amd64"
SLOT="0"
LICENSE="LGPL-2.1"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	egnustep_env
	#install themes
	mkdir -p ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes
	cp -R ${WORKDIR}/*theme ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes/
}
