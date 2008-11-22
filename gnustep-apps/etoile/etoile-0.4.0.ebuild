# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Meta-package for the Etoile desktop environment"
HOMEPAGE="http://www.etoile-project.org"

LICENSE="as-is"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

RDEPEND=">=gnustep-apps/azbackground-${PV}
	>=gnustep-apps/dictionaryreader-${PV}
	>=gnustep-apps/etoile-corner-${PV}
	>=gnustep-apps/etoile-idle-${PV}
	>=gnustep-apps/etoile-menuserver-${PV}
	>=gnustep-apps/fontmanager-${PV}
	>=gnustep-apps/melodie-${PV}
	>=gnustep-apps/scriptservices-${PV}
	>=gnustep-apps/stepchat-${PV}
	>=gnustep-apps/typewriter-${PV}
	>=gnustep-apps/vindaloo-${PV}
	>=gnustep-libs/camaelon-${PV}"
