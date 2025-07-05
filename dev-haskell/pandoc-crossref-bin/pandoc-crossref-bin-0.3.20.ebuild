# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PANDOC_PV=3.7.0.2

DESCRIPTION="Pandoc filter for cross-references"
HOMEPAGE="https://github.com/lierdakil/pandoc-crossref"
SRC_URI="https://github.com/lierdakil/pandoc-crossref/releases/download/v${PV}/pandoc-crossref-Linux-X64.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/${PANDOC_PV}"
KEYWORDS="amd64 ~x86"
IUSE=""

RESTRICT="strip"

RDEPEND="
	~app-text/pandoc-bin-${PANDOC_PV}
	!dev-haskell/pandoc-crossref
"

DEPEND="${RDEPEND}
"

S=${WORKDIR}

src_install() {
	dobin pandoc-crossref
	doman pandoc-crossref.1
}
