# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DATESTAMP="200606291905"
MY_PN="ecj"
S="${WORKDIR}"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/R-${PV}-${DATESTAMP}/${MY_PN}src.zip"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ~ppc x86"
SLOT="3.2"
IUSE="gcj"

RDEPEND="!gcj? ( >=virtual/jre-1.4 )"
DEPEND="!gcj? ( >=virtual/jdk-1.4 )
	gcj? ( >=dev-java/gcj-4.1.1 )
	sys-apps/findutils"
#PDEPEND=">=dev-java/ant-core-1.6.2
#	~dev-java/ant-eclipse-ecj-${PV}"

pkg_setup() {
	use gcj || java-pkg-2_pkg_setup
}

src_compile() {
	# own package
	rm -f org/eclipse/jdt/core/JDTCompilerAdapter.java
	rm -fr org/eclipse/jdt/internal/antadapter

	if use gcj ; then
		java-pkg_donative org || die "failed to compile to native code!"
		java-pkg_donative-bin org.eclipse.jdt.internal.compiler.batch.Main \
			${MY_PN}-native-${SLOT} || die "failed to build native binary!"
	fi

	local javac="javac"
	use gcj && javac="gcj -C -Wno-deprecated"

	for f in $(find org/ -name '*.java') ; do
		${javac} ${f}
	done

	find org/ -name '*.class' -o -name '*.properties' -o -name '*.rsc' | \
		xargs jar cf ${MY_PN}.jar
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar

	exeinto /usr/bin
	doexe ${FILESDIR}/${MY_PN}-${SLOT}
	use gcj && doexe build/${MY_PN}-native-${SLOT}

	insinto /usr/share/java-config-2/compiler
	newins ${FILESDIR}/compiler-settings-${SLOT} ${MY_PN}-${SLOT}
}

pkg_postinst() {
	ewarn "To get the Compiler Adapter of ECJ for Ant do"
	ewarn "	# emerge ant-eclipse-ecj"
}
