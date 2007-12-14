# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="International Components for Unicode for Java"

HOMEPAGE="http://icu.sourceforge.net/"
MY_PV=${PV/./_}
MY_PV=${MY_PV/./_}
SRC_URI="http://download.icu-project.org/files/${PN}/${PV}/${PN}src_${MY_PV}.jar
		doc? ( http://download.icu-project.org/files/${PN}/${PV}/${PN}docs_${MY_PV}.jar )"
LICENSE="icu"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc source"
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"

JAVA_PKG_DROP_COMPILER="jikes"

S=${WORKDIR}

src_unpack() {
	jar -xf ${DISTDIR}/${PN}src_${MY_PV}.jar || die "failed to unpack"
	if use doc; then
		mkdir docs; cd docs
		jar -xf ${DISTDIR}/${PN}src_${MY_PV}.jar || die "failed to unpack docs"
	fi
	cd ${S}
	epatch ${FILESDIR}/${P}-build.patch
}

src_compile() {
	eant jar || die "compile failed"
}

src_install() {
	java-pkg_dojar ${PN}.jar ${PN}-charsets.jar

	use doc && java-pkg_dohtml -r readme.html docs/*
	use source && java-pkg_dosrc src/*
}

src_test() {
	eant check
}
