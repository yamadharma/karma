# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A DjVu to PDF converter with a focus on small output size and the ability to preserve document outlines and text layers"
HOMEPAGE="https://github.com/kcroker/dpsprep"
SRC_URI="https://github.com/kcroker/dpsprep/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3.0-only"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~riscv x86"

RDEPEND="
	>=dev-python/pillow-9.1.0[${PYTHON_USEDEP}]
	dev-python/python-djvulibre[${PYTHON_USEDEP}]
	dev-python/pdfrw[${PYTHON_USEDEP}]
	dev-python/fpdf2[${PYTHON_USEDEP}]
	dev-python/loguru[${PYTHON_USEDEP}]
	app-text/OCRmyPDF
"

src_install() {
	distutils-r1_src_install

	dobin ${S}/bin/dpsprep
	doman dpsprep.1
}
