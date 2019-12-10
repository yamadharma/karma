# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Treemacs - a tree layout file explorer for Emacs"
HOMEPAGE="https://github.com/Alexander-Miller/treemacs"
SRC_URI="https://github.com/Alexander-Miller/treemacs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"

#S="${WORKDIR}/Emacs-D-Mode-${PV}"
# SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake
}