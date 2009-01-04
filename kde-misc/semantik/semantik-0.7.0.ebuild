# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit kde4-base

DESCRIPTION="Semantik - a mindmapping-like tool for document generation."
HOMEPAGE="http://freehackers.org/~tnagy/semantik.html"
SRC_URI="http://freehackers.org/~tnagy/${P}.tar.bz2"

LICENSE="QPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=x11-libs/qt-4.2
	>=dev-lang/python-2.3
	>=dev-lang/swig-1.3.31
	dev-lang/ocaml"
RDEPEND=">=x11-libs/qt-4.2
        >=dev-lang/python-2.4.2"
S=${WORKDIR}/${P}

src_configure() {
	./waf configure --prefix=/usr/ || die
}

src_compile() {
	./waf || die
}

src_install() {
	DESTDIR=${D} ./waf install
}
