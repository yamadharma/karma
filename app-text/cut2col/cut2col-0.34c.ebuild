# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2

DESCRIPTION="utility for converting 2-column to 1-column pdf documents"
HOMEPAGE="http://www.cp.eng.chula.ac.th/~somchai/cut2col/"
SRC_URI="http://www.cp.eng.chula.ac.th/%7Esomchai/cut2col/${PN}-v${PV/0./}.jar"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}"

RESTRICT=mirror

src_unpack() {
	mkdir ${S}
}

src_install() {
	java-pkg_newjar ${DISTDIR}/${PN}-v${PV/0./}.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar
}