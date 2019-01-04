# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Draw UML diagrams using a simple and human readable text description"
HOMEPAGE="http://plantuml.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
#SRC_URI="mirror://sourceforge/${PN}/${P/-/.}.jar"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.7
	dev-java/jlatexmath"

RDEPEND=">=virtual/jre-1.7
	dev-java/ant-core:0
	>=media-gfx/graphviz-2.26.3"

EANT_BUILD_TARGET="dist"
EANT_GENTOO_CLASSPATH="ant-core"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_prepare() {
	default
	sed -i -e "s:jlatexmath.*\?.jar:$(java-pkg_getjars jlatexmath-1):g" \
		-e "s://:/:g" \
			build.xml || die

}


src_configure() {
	default
	JAVA_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars jlatexmath-1)"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar
	use source && java-pkg_dosrc src/*
}