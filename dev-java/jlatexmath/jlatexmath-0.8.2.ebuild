# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgraph/jgraph-5.12.0.4.ebuild,v 1.5 2008/05/13 21:09:16 ken69267 Exp $

EAPI=2

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java API to render LaTeX"
SRC_URI="http://forge.scilab.org/index.php/p/${PN}/downloads/19/get/ -> ${P}.tar.gz"
HOMEPAGE="http://forge.scilab.org/index.php/p/jlatexmath"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64"

EANT_BUILD_TARGET="buildJar"
EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/org
}
