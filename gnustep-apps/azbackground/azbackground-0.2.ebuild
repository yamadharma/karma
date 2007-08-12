# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/AZBackground"

DESCRIPTION="A background image setter for the Etoile project"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND="gnustep-libs/xwindowserverkit"
RDEPEND="${DEPEND}"
