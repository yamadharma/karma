# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Cask is a project management tool for Emacs"
HOMEPAGE="https://github.com/cask/cask"
SRC_URI="https://github.com/cask/cask/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"

src_compile() {
	emake
}

