# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgroups/jgroups-2.2.7-r2.ebuild,v 1.1 2006/08/15 10:01:18 nelchael Exp $

inherit eutils java-pkg-opt-2

DESCRIPTION="Ganttproject ... project management as free as bee(r)"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://ganttproject.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
RDEPEND=">=virtual/jre-1.4"

DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	>=dev-java/ant-core-1.5
	app-arch/unzip"

S="${WORKDIR}/${P}-src"

src_unpack() {
	unpack "${A}"
}

src_compile() {
	cd ganttproject-builder
	ant || die "build failed"
}

src_install() {
	cd "${S}"/ganttproject
	dodoc README COPYING AUTHORS
	
	cd "${S}"/ganttproject-builder
	insinto "${DESTTREE}/share/${PN}/lib"
	doins ganttproject-eclipsito-config.xml

	cd dist-bin

	java-pkg_dojar eclipsito.jar
	cp -dPR plugins "${D}${DESTTREE}/share/${PN}/lib"
	
	cat > ${PN} <<EOF
#!/bin/sh

LOCAL_CLASSPATH=\$(java-config -p ${PN})

CONFIGURATION_FILE="${DESTTREE}/share/${PN}/lib/ganttproject-eclipsito-config.xml"
BOOT_CLASS=org.bardsoftware.eclipsito.Boot

# Gantt Project does not handle absolute paths!!!
# So, if we don't change to / it complains about
# not finding configuration file
cd /

exec "\$(java-config -J)" -Xmx256m -classpath "\${CLASSPATH}:\${LOCAL_CLASSPATH}" \$BOOT_CLASS "\$CONFIGURATION_FILE" "\$@"
EOF
	dobin ${PN}
}
