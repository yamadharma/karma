# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The 'jpwgen' program is a Java-based password generator whose functionality resembles the popular 'pwgen' program."
HOMEPAGE="http://jpwgen.berlios.de/"
SRC_URI="morror://berlios/jpwgen/jpwgen-${PV}-sources.jar"

LICENSE="W3C"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="dev-java/commons-logging
	   dev-java/commons-cli"

S="${WORKDIR}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}
	app-arch/unzip"

src_unpack() {
	unpack ${A}

	cp "${FILESDIR}/build.xml" "${S}"

	cd "${S}"

	mkdir src
	mv de src
	echo "classpath=$(java-pkg_getjars commons-cli-1,commons-logging)" > "${S}"/build.properties
}

EANT_DOC_TARGET=""

src_install() {
	java-pkg_dojar "${S}"/dist/jpwgen.jar
	java-pkg_dolauncher ${PN} --main de.rrze.idmone.utils.jpwgen.PwGenerator

	use source && java-pkg_dosrc "${S}"/src/*
}
