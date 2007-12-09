# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

MY_PN="ecj"
MY_PV="${PV/_pre/M}"
DMF="S-${MY_PV}-200711012000"
S="${WORKDIR}"

DESCRIPTION="Ant Compiler Adapter for Eclipse Java Compiler"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF/.0}/${MY_PN}src-${MY_PV}.zip"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ~ppc x86"
SLOT="3.4"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	~dev-java/eclipse-ecj-${PV}
	>=dev-java/ant-core-1.7"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.4
	sys-apps/findutils"

src_unpack() {
	unpack ${A}
	mkdir -p src/org/eclipse/jdt/{core,internal}
	cp org/eclipse/jdt/core/JDTCompilerAdapter.java \
		src/org/eclipse/jdt/core || die
	cp -r org/eclipse/jdt/internal/antadapter \
		src/org/eclipse/jdt/internal || die
	rm -fr about* org
}

src_compile() {
	cd src
	ejavac -classpath "$(java-config -p ant-core,eclipse-ecj-${SLOT})" \
		`find org/ -name '*.java'` || die "ejavac failed!"
	find org/ -name '*.class' -o -name '*.properties' | \
			xargs jar cf ${S}/${PN}.jar || die "jar failed!"
}

src_install() {
	java-pkg_dojar ${PN}.jar

	insinto /usr/share/java-config-2/compiler
	newins ${FILESDIR}/compiler-settings-${SLOT} ${MY_PN}-${SLOT}
}
