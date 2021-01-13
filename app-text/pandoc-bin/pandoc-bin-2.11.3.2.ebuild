# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Conversion between markup formats"
HOMEPAGE="http://pandoc.org"
SRC_URI="https://github.com/jgm/pandoc/releases/download/${PV}/pandoc-${PV}-linux-amd64.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE=""

RESTRICT="strip"

RDEPEND="
	!app-text/pandoc
	!dev-haskell/pandoc-citeproc
"
DEPEND="${RDEPEND}
"

PDEPEND="
	dev-haskell/pandoc-crossref-bin
"


S=${WORKDIR}/pandoc-${PV}

src_install() {
	dobin bin/*
	doman share/man/man1/*
}


