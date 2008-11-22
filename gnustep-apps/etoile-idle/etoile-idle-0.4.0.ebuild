# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/Idle"

DESCRIPTION="sends user-idle notifications every minute that the user is idle"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"
IUSE=""

DEPEND="x11-libs/libXScrnSaver"
RDEPEND="${DEPEND}"
