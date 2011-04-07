# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit kde4-base

DESCRIPTION="Semantik - a mindmapping-like tool for document generation."
HOMEPAGE="http://freehackers.org/~tnagy/semantik.html"
SRC_URI="http://freehackers.org/~tnagy/${P}.tar.bz2"

LICENSE="QPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml
	dev-lang/python
"
RDEPEND="
	x11-libs/qt-core
	x11-libs/qt-gui
	x11-libs/qt-xmlpatterns
	dev-lang/python[xml]
"
S=${WORKDIR}/${P}

src_prepare () {
	epatch ${FILESDIR}/${P}-wscript_ldconfig.patch
}

src_configure() {
	./waf configure --prefix=/usr/ || die
}

src_compile() {
	./waf || die
}

src_install() {
	DESTDIR=${D} ./waf install
}
