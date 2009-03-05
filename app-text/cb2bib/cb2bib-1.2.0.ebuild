# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License vse/xorg-x11
# $Header: $

DESCRIPTION="Tool for extracting unformatted bibliographic references"
HOMEPAGE="http://www.molspaces.com/cb2bib/"
SRC_URI="http://www.molspaces.com/dl/progs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=x11-libs/qt-4.4 
	x11-base/xorg-x11"
RDEPEND="app-text/poppler"

src_compile() {
	./configure --qmakepath /usr/bin/qmake --prefix /usr --datadir /usr/share || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dobin bin/cb2bib
	dodir /usr/share/cb2bib
	cp -R ${S}/data ${S}/c2btools ${S}/testPDFImport ${D}/usr/share/cb2bib || die "install failed!"
	insinto /usr/share/pixmaps
	doins src/icons/cb2bib.png
	insinto /usr/share/applications
	doins *.desktop
}
