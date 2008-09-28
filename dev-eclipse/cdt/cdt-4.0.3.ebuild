# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="3.3"
inherit eclipse-ext-2

DESCRIPTION="Eclipse C/C++ Development Tools"
HOMEPAGE="http://www.eclipse.org/cdt/"
SRC_URI="mirror://eclipse/tools/cdt/releases/europa/dist/cdt-master-${PV}.zip"
LICENSE="EPL-1.0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

ECLIPSE_EXT_FEATURES="org.eclipse.cdt"
S="${WORKDIR}"

src_unpack() {
	base_src_unpack

	# Delete the Linux GTK source JARs that don't match our arch because they will clash when preparing to build.
	find "${S}" plugins -maxdepth 1 -name "org.eclipse.cdt.source.linux.gtk.*.jar" ! -name "*.${ECLIPSE_ARCH}_*" -delete || die

	eclipse-ext-2_prepare-usual-sdk
	eclipse-ext-2_discover-components
}

src_compile() {
	# Build native libraries and copy them into place.
	cd "${S}"/plugins/org.eclipse.cdt.source.linux.gtk.${ECLIPSE_ARCH}_*/src || die
	emake -C org.eclipse.cdt.core.linux_*/library ARCH="${ECLIPSE_ARCH}" || die
	cp -a org.eclipse.cdt.core.linux.${ECLIPSE_ARCH}/* ../../org.eclipse.cdt.core.linux.${ECLIPSE_ARCH}_* || die

	eclipse-ext-2_src_compile
}
