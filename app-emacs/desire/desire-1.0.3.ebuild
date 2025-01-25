# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Desire package for Emacs Configuration Framework "
HOMEPAGE="https://github.com/yamadharma/desire"
SRC_URI="https://github.com/yamadharma/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND=""
BDEPEND="${RDEPEND}"
RESTRICT="network-sandbox"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile desire.el
	elisp-compile desirepath.el
}

src_install() {
	elisp_src_install
	cp -R ecf-mule ${D}/${SITELISP}/${PN}
}
