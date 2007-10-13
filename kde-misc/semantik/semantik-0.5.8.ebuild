# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4 eutils

DESCRIPTION="Semantik - a mindmapping-like tool for document generation."
HOMEPAGE="http://freehackers.org/~tnagy/kdissert.html"
SRC_URI="http://freehackers.org/~tnagy/${P}.tar.bz2"

LICENSE="QPL"
SLOT="0"
KEYWORDS="x86 amd64"
#IUSE=""

DEPEND="$(qt4_min_version 4.2) 
	>=dev-lang/python-2.3
	>=dev-lang/swig-1.3.31
	dev-lang/ocaml"
RDEPEND="$(qt4_min_version 4.2)
        >=dev-lang/python-2.3"
S=${WORKDIR}/${P}

src_compile() {
	./waf configure --prefix=/usr/ || die
	./waf || die
}

src_install() {
	DESTDIR=${D} ./waf install
}
