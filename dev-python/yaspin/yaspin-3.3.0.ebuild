# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1

DESCRIPTION="Yet Another Terminal Spinner for Python"
HOMEPAGE="https://github.com/pavdmyt/yaspin"
SRC_URI="https://github.com/pavdmyt/yaspin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-python/termcolor[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}"
BDEPEND=""
