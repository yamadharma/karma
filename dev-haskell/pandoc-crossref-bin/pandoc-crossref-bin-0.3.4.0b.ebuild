# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PANDOC_PV=2.5

DESCRIPTION="Pandoc filter for cross-references"
HOMEPAGE="https://github.com/lierdakil/pandoc-crossref#readme"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"
SRC_URI="https://github.com/lierdakil/pandoc-crossref/releases/download/v${PV}/linux-pandoc_${PANDOC_PV/./_}.tar.gz -> ${P}-${PANDOC_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PANDOC_PV}"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	!dev-haskell/pandoc-crossref
"

DEPEND="${RDEPEND}
"

S=${WORKDIR}

src_install() {
	dobin pandoc-crossref
	doman pandoc-crossref.1
}
