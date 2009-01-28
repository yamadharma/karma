# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SLOT="3.4"
ECLIPSE_NAME=ganymede
inherit eclipse-ext-2

DESCRIPTION="Eclipse C/C++ Development Tools"
HOMEPAGE="http://www.eclipse.org/cdt/"
SRC_URI="mirror://eclipse/tools/cdt/releases/${ECLIPSE_NAME}/dist/cdt-master-${PV}.zip"
LICENSE="EPL-1.0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

ECLIPSE_EXT_FEATURES="org.eclipse.cdt"
S="${WORKDIR}"

src_unpack() {
	base_src_unpack
}

src_prepare() {
	# Delete the Linux GTK source JARs that don't match our arch because they will clash when preparing to build.
	find "${S}" plugins -maxdepth 1 -name "org.eclipse.cdt.platform.source.linux.gtk.*.jar" ! -name "*.${ECLIPSE_ARCH}_*" -delete || die
	find "${S}" plugins -maxdepth 1 -name "org.eclipse.cdt.core.linux.*.jar" ! -name "*.${ECLIPSE_ARCH}_*" -delete || die

for i in solaris qnx macosx aix win32
do
	find "${S}" plugins -maxdepth 1 -name "*${i}*" -delete
done

	# Delete Cyngwin and Mingwin
#	find "${S}" plugins -type d -name "*cygwin*.jar" -delete || die
#	find "${S}" plugins -type d -name "*mingw*.jar" -delete || die
#	find "${S}" plugins -type d -name "*win32*.jar" -delete || die

	eclipse-ext-2_prepare-usual-sdk
	eclipse-ext-2_discover-components
}

src_compile() {
	# Build native libraries and copy them into place.
	cd "${S}"/plugins/org.eclipse.cdt.platform.source.linux.gtk.${ECLIPSE_ARCH}_*/src || die
	emake -C org.eclipse.cdt.core.linux_*/library ARCH="${ECLIPSE_ARCH}" || die
	cp -a org.eclipse.cdt.core.linux.${ECLIPSE_ARCH}/* ../../org.eclipse.cdt.core.linux.${ECLIPSE_ARCH}_* || die

	eclipse-ext-2_src_compile
}
