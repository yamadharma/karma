# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="A simple cross-platform application for cropping PDF files"
HOMEPAGE="http://briss.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}"

RESTRICT=mirror

src_install() {
	dodir /opt/briss || die "can't create /opt/briss"

	insinto /opt/briss
	doins *.jar || die "can't install *.jar"

	dodoc *.txt || die "can't creat docs"

	exeinto /opt/bin
	doexe "${FILESDIR}"/briss || die "can't install briss-bin"
	sed -i -e "s/@PV@/${PV}/g" ${D}/opt/bin/briss
}