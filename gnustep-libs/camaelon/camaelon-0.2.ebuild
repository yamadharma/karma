# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Bundles/${PN/c/C}"

DESCRIPTION="Camaelon allows you to load theme bundles for GNUstep."

HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Camaelon"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
KEYWORDS="x86 ~ppc ~sparc ~alpha amd64"
SLOT="0"
LICENSE="LGPL-2.1"

src_install() {
	gnustep-base_src_install

	#Link default theme
	mkdir -p ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes
	ln -s ${GNUSTEP_SYSTEM_LIBRARY}/Bundles/Camaelon.themeEngine/Resources/Nesedah.theme ${D}${GNUSTEP_SYSTEM_LIBRARY}/Themes/
}

gnustep_config_script() {
	echo "echo ' * setting NSGlobalDomain GSAppKitUserBundles'"
	echo "defaults write NSGlobalDomain GSAppKitUserBundles '(\"/usr/GNUstep/System/Library/Bundles/Camaelon.themeEngine\")'"
	echo "echo ' * using Camaelon Theme: Nesdah'"
	echo "defaults write Camaelon Theme Nesedah"
}
