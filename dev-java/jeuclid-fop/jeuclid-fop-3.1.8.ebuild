# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2
EAPI="2"
DESCRIPTION="Jeuclid MathML support for FOP."
HOMEPAGE="http://jeuclid.sourceforge.net"
SRC_URI="mirror://sourceforge/jeuclid/jeuclid-parent-${PV}-src.zip"
LICENSE="Apache-2.0"
SLOT="0"
RESTRICT=""
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"

COMMON_DEPEND="
	>=dev-java/batik-1.7
	dev-java/commons-logging
	>=dev-java/fop-0.95_beta[hyphenation]
	=dev-java/jeuclid-core-${PV}
	>=dev-java/xml-commons-external-1.3
	>=dev-java/xmlgraphics-commons-1.3"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core
	app-arch/unzip
	app-arch/zip
	${COMMON_DEPEND}"

S="${WORKDIR}/jeuclid-parent-${PV}/${PN}"

src_unpack() {
	unpack ${A}

	cd ${S} || die

	# create directory for dependencies
	mkdir lib || die
	cd lib || die

	# add dependencies into the lib dir
	java-pkg_jar-from batik-1.7 batik-all.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from fop fop.jar
	java-pkg_jar-from fop fop-hyph.jar
	java-pkg_jar-from jeuclid-core jeuclid-core.jar
	java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
	java-pkg_jar-from xmlgraphics-commons-1 xmlgraphics-commons.jar
}

src_install() {
	# install JAR file
	java-pkg_dojar target/${PN}.jar

	# create FOP wrapper script
	java-pkg_dolauncher fopmml --main org.apache.fop.cli.Main

	dodoc README
}

pkg_postinst() {
	einfo "Use command 'fopmml' for using FOP with MathML support."
}
