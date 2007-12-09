# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-utils-2

MY_PN="ecj"
MY_PV="${PV/_pre/M}"
DMF="S-${MY_PV}-200711012000"
S="${WORKDIR}"

DESCRIPTION="Eclipse Compiler for Java"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_PN}src-${MY_PV}.zip"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ~ppc x86"
SLOT="3.4"
IUSE="gcj"

RDEPEND="!gcj? ( >=virtual/jre-1.4 )"
DEPEND="!gcj? ( >=virtual/jdk-1.4 )
	gcj? ( >=dev-java/gcj-4.1.1 )
	sys-apps/findutils"

src_unpack() {
	unpack ${A}
	cd ${S}

	# own package
	rm -f org/eclipse/jdt/core/JDTCompilerAdapter.java
	rm -fr org/eclipse/jdt/internal/antadapter

	# what the heck...?! java6
	rm -fr org/eclipse/jdt/internal/compiler/tool/ \
		org/eclipse/jdt/internal/compiler/apt/

	# gcj feature
	epatch ${FILESDIR}/${PN}-gcj.patch
}

src_compile() {
	local javac="javac" java="java" jar="jar"
	use gcj && java="$(gcj-config --gij)" jar="$(gcj-config --gjar)" \
		javac="$(gcj-config --gcj) -C -w -g0 --encoding=ISO-8859-1"

	mkdir -p bootstrap
	cp -a org bootstrap

	einfo "bootstrapping ${MY_PN} with javac"

	cd ${S}/bootstrap
	if use gcj; then
		if ! [[ $(gcj-config --version) =~ ^4.3 ]]; then
			for f in $(find org/ -name '*.java'); do
				${javac} ${f} || die "${MY_PN} bootstrap failed!"
			done
		else
			${javac} $(find org/ -name '*.java') || die "${MY_PN} bootstrap failed!"
		fi
	else
		${javac} $(find org/ -name '*.java') || die "${MY_PN} bootstrap failed!"
	fi

	find org/ -name '*.class' -o -name '*.properties' -o -name '*.rsc' | \
		xargs ${jar} cf ${MY_PN}.jar

	einfo "build ${MY_PN} with bootstrapped ${MY_PN}"

	cd ${S}
	${java} -classpath bootstrap/${MY_PN}.jar \
		org.eclipse.jdt.internal.compiler.batch.Main -encoding ISO-8859-1 org \
		|| die "${MY_PN} build failed!"
	find org/ -name '*.class' -o -name '*.properties' -o -name '*.rsc' | \
		xargs ${jar} cf ${MY_PN}.jar
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar

	exeinto /usr/bin
	doexe ${FILESDIR}/${MY_PN}-${SLOT}
}

pkg_postinst() {
	java-pkg_reg-cachejar_
	ewarn "to get the Compiler Adapter of ECJ for ANT do"
	ewarn "	# emerge ant-eclipse-ecj"
}
