# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PV=${PV}

S=${WORKDIR}/GWorkspace-${MY_PV}/GWMetadata

DESCRIPTION="A clipboard for GNUstep that can hold things for later copy and paste."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/gworkspace-${MY_PV}.tar.gz"

KEYWORDS="x86 amd64 ~ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	>=gnustep-apps/gworkspace-${MY_PV}
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8"
	
RDEPEND="${GS_RDEPEND}
	>=gnustep-apps/gworkspace-${MY_PV}
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8"

egnustep_install_domain "System"

src_compile() {
	egnustep_env

	econf || die "configure failed"
	
	egnustep_make || die "make failed"
}
