# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/Private/System

DESCRIPTION="Meta-package for the Etoile desktop environment"
HOMEPAGE="http://www.etoile-project.org"
# SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="as-is"
KEYWORDS="x86 amd64"
SLOT="0"

RDEPEND=">=gnustep-apps/addresses-0.4.7
	~gnustep-apps/azalea-${PV}
	~gnustep-apps/azbackground-${PV}
	~gnustep-apps/azdock-${PV}
	~gnustep-apps/azswitch-${PV}
	~gnustep-apps/calc-${PV}
	~gnustep-apps/dictionaryreader-${PV}
	~gnustep-apps/etoile-corner-${PV}
	~gnustep-apps/etoile-idle-${PV}
	~gnustep-apps/etoile-menuserver-${PV}
	~gnustep-apps/etoile-system-${PV}
	~gnustep-apps/fontmanager-${PV}
	~gnustep-apps/grr-${PV}
	~gnustep-apps/outerspace-${PV}
	~gnustep-apps/sketch-${PV}
	~gnustep-apps/stepchat-${PV}
	~gnustep-apps/typewriter-${PV}
	~gnustep-apps/vindaloo-${PV}
	~gnustep-libs/camaelon-${PV}
	~gnustep-libs/etoile-behavior-${PV}
	~gnustep-libs/etoile-wildmenus-${PV}"

src_unpack() {
    	subversion_src_unpack 
	cd ${S1}
	
	# Fix path
	egnustep_env
	sed -i "s#/usr/local/bin/etoile#${GNUSTEP_SYSTEM_TOOLS}/etoile_system#" \
		etoile.desktop || die "Fixing desktop file failed"
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	egnustep_env
	cd ${S1}
	# Install SystemTaskList
	dodir ${GNUSTEP_SYSTEM_LIBRARY}/Etoile
	insinto ${GNUSTEP_SYSTEM_LIBRARY}/Etoile
	doins SystemTaskList.plist	

	# Install desktop entry file
	insinto /usr/share/xsessions
	doins etoile.desktop
}

pkg_postinst() {
	elog "Thanks for trying Etoile ebuilds from the GNUstep overlay"
	elog "This is still a work in progress. For now,"
	elog "to enable all Etoile features, you will need to run (as user):"
	elog "# defaults write NSGlobalDomain GSAppKitUserBundles '("
	elog "\"/usr/GNUstep/System/Library/Bundles/Camaelon.themeEngine\","
	elog "\"/usr/GNUstep/System/Library/Bundles/EtoileMenus.bundle\","
	elog "\"/usr/GNUstep/System/Library/Bundles/EtoileBehavior.bundle\")'"
	elog "This will probably be changed in the near future"
}
