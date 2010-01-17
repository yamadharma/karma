# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Jeuclid MathML viewer."
HOMEPAGE="http://jeuclid.sourceforge.net"
SRC_URI="mirror://sourceforge/jeuclid/jeuclid-parent-${PV}-src.zip"
LICENSE="Apache-2.0"
SLOT="0"
RESTRICT=""
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"

COMMON_DEPEND="
	>=dev-java/apple-java-extensions-bin-1.2
	dev-java/commons-logging
	=dev-java/jeuclid-core-${PV}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core
	app-arch/unzip
	${COMMON_DEPEND}"

S="${WORKDIR}/jeuclid-parent-${PV}/${PN}"

src_unpack() {
	unpack ${A}

	cd ${S} || die

	# create directory for dependencies
	mkdir lib || die
	cd lib || die

	# add dependencies into the lib dir
	java-pkg_jar-from apple-java-extensions-bin AppleJavaExtensions.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from jeuclid-core jeuclid-core.jar
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	# create wrapper script
	java-pkg_dolauncher mathviewer --main net.sourceforge.jeuclid.app.mathviewer.MathViewer
}
