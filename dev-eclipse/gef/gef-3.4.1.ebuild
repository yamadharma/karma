# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

BUILD="R200802211602"

SLOT="3.4"
inherit eclipse-ext-2

DESCRIPTION="Allows developers to take an existing application model and easily create a rich graphical editor"
HOMEPAGE="http://www.eclipse.org/gef/"
SRC_URI="mirror://eclipse/tools/gef/downloads/drops/${PV}/${BUILD}/GEF-ALL-${PV}.zip"
LICENSE="EPL-1.0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

ECLIPSE_EXT_FEATURES="org.eclipse.gef"
PREPARE_USUAL_SDK=1
S="${WORKDIR}/eclipse"
