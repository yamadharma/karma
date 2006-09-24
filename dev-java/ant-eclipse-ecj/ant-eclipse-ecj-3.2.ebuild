# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DATESTAMP="200606291905"
S="${WORKDIR}"

DESCRIPTION="Ant Compiler Adapter for Eclipse Java Compiler"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/R-${PV}-${DATESTAMP}/ecjsrc.zip"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ~ppc x86"
SLOT="3.2"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	~dev-java/eclipse-ecj-${PV}
	>=dev-java/ant-core-1.6.2"
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
	ejavac -cp "$(java-config -p ant-core,eclipse-ecj-${SLOT})" \
		`find org/ -name '*.java'` || die "ejavac failed!"
	find org/ -name '*.class' -o -name '*.properties' | \
			xargs jar cf ${S}/${PN}.jar || die "jar failed!"
}

src_install() {
	java-pkg_dojar ${PN}.jar
}
