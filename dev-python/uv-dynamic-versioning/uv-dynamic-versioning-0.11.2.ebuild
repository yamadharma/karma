# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( python3_1{1..4} )

inherit distutils-r1 pypi

HOMEPAGE="https://github.com/ninoseki/uv-dynamic-versioning"
DESCRIPTION="Dynamic versioning based on VCS tags for uv/hatch project"
SRC_URI="https://github.com/ninoseki/uv-dynamic-versioning/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/dunamai-1.25[${PYTHON_USEDEP}]
	>=dev-python/hatchling-1.26[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.0[${PYTHON_USEDEP}]
	>=dev-python/tomlkit-0.13[${PYTHON_USEDEP}]"

S=${WORKDIR}/${P}
