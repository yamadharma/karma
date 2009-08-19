# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Annotations for Concurrency"
HOMEPAGE="http://www.jcip.net/"
SRC_URI="http://www.jcip.net/${PN}-src.jar"
LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"

src_compile() {
	mkdir -p build
	ejavac -d build $(find net -name '*.java')
	cd build
	jar -cf "${PN}.jar" *
}

src_install() {
	java-pkg_dojar build/"${PN}.jar"
	use source && java-pkg_dosrc net
}
