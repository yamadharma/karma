# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Services/Private/MenuServer"

DESCRIPTION="Menubar's background for Etoile."
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND="gnustep-libs/xwindowserverkit
	gnustep-apps/etoile-system"
RDEPEND="${DEPEND}"
