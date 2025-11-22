# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="poetry"
PYTHON_COMPAT=( python3_1{1..4} )

inherit distutils-r1 pypi

HOMEPAGE="https://github.com/mtkennerly/dunamai"
DESCRIPTION="Dynamic version generation"
SRC_URI="https://github.com/mtkennerly/dunamai/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

IUSE="test"

BDEPEND="
	test? (
	dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pre-commit[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/ruff[${PYTHON_USEDEP}]
		dev-python/argparse-manpage[${PYTHON_USEDEP}]
	)
"
