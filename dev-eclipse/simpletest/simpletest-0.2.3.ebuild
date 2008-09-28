# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="3.4"
inherit eclipse-ext-2

DESCRIPTION="Eclipse plugin for the SimpleTest PHP testing framework"
HOMEPAGE="http://www.lastcraft.com/simple_test.php"
SRC_URI="http://dev.gentooexperimental.org/~chewi/distfiles/${P}.tar.lzma"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.4"

RDEPEND=">=virtual/jre-1.4
	dev-php/simpletest"

ECLIPSE_EXT_FEATURES="net.sf.simpletest.eclipse.feature"

src_install() {
	# Delete the simpletest zip if it exists. You should delete this when making the tarball.
	rm -f "${BUILD_DIR}/tmp/plugins/net.sf.simpletest.eclipse_${PV}/simpletest_php.zip"

	# Replace the zip with a symlink to the simpletest directory.
	ln -snf "/usr/share/php/simpletest" "${BUILD_DIR}/tmp/plugins/net.sf.simpletest.eclipse_${PV}/simpletest" || die

	eclipse-ext-2_src_install
}
