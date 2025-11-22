# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_1{1..4} )

inherit distutils-r1 pypi

DESCRIPTION="A server for file conversions with Libre Office"
SRC_URI="https://github.com/unoconv/unoserver/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

HOMEPAGE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="${PYTHON_DEPS}
		virtual/ooo
		"
