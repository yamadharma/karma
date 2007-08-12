# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/InspectorKit"

DESCRIPTION="Commonly used inspector adapted for Etoile"
HOMEPAGE="http://www.etoile-project.org/etoile/mediawiki/index.php?title=Frameworks_Suite"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND="gnustep-libs/panekit"
RDPEND="${DEPEND}"
