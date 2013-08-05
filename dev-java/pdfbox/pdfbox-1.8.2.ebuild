# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=4
JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library and utilities for working with PDF documents"
HOMEPAGE="http://pdfbox.apache.org/"
GITHUB_USER="jukka"
#https://github.com/jukka/pcfi/archive/master.zip
SRC_URI="mirror://apache/${PN}/${PV}/${P}-src.zip"
#ADOBE_FILES="pcfi-2010.08.09.jar"
#	http://repo2.maven.org/maven2/com/adobe/pdf/pcfi/2010.08.09/${ADOBE_FILES}"
LICENSE="BSD"
SLOT="1.7"
KEYWORDS="~amd64 x86"
IUSE=""

CDEPEND=">=dev-java/bcprov-1.45:0
	>=dev-java/bcmail-1.45
	>=dev-java/commons-logging-1.1.1:0
	dev-java/icu4j:4
	dev-java/pcfi:0
	>=dev-java/fontbox-${PV}:${SLOT}
	>=dev-java/jempbox-${PV}:${SLOT}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	test? (
		dev-java/junit:4
		dev-java/ant-junit:0 )
	${CDEPEND}"

JAVA_PKG_FILTER_COMPILER="jikes"
S="${WORKDIR}/${P}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="bcprov,bcmail,commons-logging,fontbox-${SLOT},icu4j-4,jempbox-${SLOT}"
EANT_BUILD_TARGET="pdfbox.package"
EANT_EXTRA_ARGS="-Dexist=true"

src_unpack() {
	unpack ${P}-src.zip
}

java_prepare() {
#	epatch "${FILESDIR}"/${P}-build.xml.patch
#	epatch "${FILESDIR}"/${P}-disable-TestPDDocumentCatalog.patch
#	epatch "${FILESDIR}"/${P}-use-adobe-pcfi.patch
	mkdir -v download external
	ln -s "${DISTDIR}/${ADOBE_FILES}" download
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4,pcfi"
EANT_GENTOO_CLASSPATH_EXTRA="target/${P}.jar:src/main/resources:target/test-classes"

src_test() {
	#TODO: not all tests are passed; investigate why.
	java-pkg-2_src_test
}

src_compile() {
	eant -f build.xml
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
	#TODO: make launchers and postinstall messages?
}
