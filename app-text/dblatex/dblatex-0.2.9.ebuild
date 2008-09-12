# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Transform DocBook using TeX macros"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://dblatex.sourceforge.net/"

KEYWORDS="x86 amd64"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
DEPEND="virtual/latex-base"

src_compile() {
	python setup.py build || die "build failed"
}

src_install() {
	python setup.py install --root ${D} || die "install failed"
	sed -i "s:${D}:/:g" ${D}/usr/bin/dblatex 
	mv ${D}/usr/bin/dblatex ${D}/usr/bin/docbook2latex
	mv ${D}/usr/share/man/man1/dblatex.1.gz ${D}/usr/share/man/man1/docbook2latex.1.gz
	mv ${D}/usr/share/doc/${PN} ${D}/usr/share/doc/${PF}
	dodoc COPYRIGHT
}

