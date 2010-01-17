# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Core module of MathML rendering solution."
HOMEPAGE="http://jeuclid.sourceforge.net"
SRC_URI="mirror://sourceforge/jeuclid/jeuclid-parent-${PV}-src.zip"
LICENSE="Apache-2.0"
SLOT="0"
RESTRICT=""
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"

COMMON_DEPEND="
	dev-java/ant-core
	>=dev-java/batik-1.7
	dev-java/commons-logging
	dev-java/jcip-annotations
	>=dev-java/xml-commons-external-1.3
	>=dev-java/xmlgraphics-commons-1.3
	dev-java/freehep-graphics2d
	dev-java/freehep-export"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}"

S="${WORKDIR}/jeuclid-parent-${PV}/${PN}"

src_unpack() {
	unpack ${A}

	cd ${S} || die

	# remove support of FreeHep from JAVA files (not needed for FOP plugin)
#	rm -f src/main/java/net/sourceforge/jeuclid/converter/FreeHep*
#	epatch ${FILESDIR}/${PN}-freehep.patch

	# create directory for dependencies
	mkdir lib || die
	cd lib || die

	# add dependencies into the lib dir
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from batik-1.7 batik-all.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from jcip-annotations jcip-annotations.jar
	java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
	java-pkg_jar-from xmlgraphics-commons-1.3 xmlgraphics-commons.jar
	java-pkg_jar-from freehep-graphics2d freehep-graphics2d.jar
	java-pkg_jar-from freehep-util freehep-util.jar
	java-pkg_jar-from freehep-export freehep-export.jar
}

src_install() {
	java-pkg_dojar target/${PN}.jar
}
