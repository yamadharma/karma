# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="3.3"
inherit eclipse-ext-2

DESCRIPTION="Subversion plugin for Eclipse"
HOMEPAGE="http://subclipse.tigris.org"
SRC_URI="http://subclipse.tigris.org/files/documents/906/39521/subclipse-source_${PV}.zip"
LICENSE="EPL-1.0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="=dev-util/svnclientadapter-1.2.4"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

ECLIPSE_EXT_FEATURES="org.tigris.subversion.subclipse"
S="${WORKDIR}"

src_unpack() {
	eclipse-ext-2_src_unpack
	eclipse-ext-2_bundled-to-external --with-dependencies "lib\/" svnclientadapter "${WORKDIR}/build/plugins/core/META-INF/MANIFEST.MF"
}
