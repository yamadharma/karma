# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( python3_1{1..4} )

inherit distutils-r1 pypi

HOMEPAGE="https://github.com/jlevy/strif"
DESCRIPTION="Tiny, useful Python lib for strings and files"
SRC_URI="https://github.com/jlevy/strif/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
		dev-python/uv-dynamic-versioning
		"
