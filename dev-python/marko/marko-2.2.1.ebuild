# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517="pdm-backend"
PYTHON_COMPAT=( python3_1{1..4} )

inherit distutils-r1 pypi
HOMEPAGE="https://github.com/frostming/marko"
DESCRIPTION="A markdown parser with high extensibility."
SRC_URI="https://github.com/frostming/marko/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="
	test? (
	dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		>=dev-python/mypy-0.950[${PYTHON_USEDEP}]
	)
"
