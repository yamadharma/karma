# Copyright 2025
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517="hatchling"
PYTHON_COMPAT=( python3_1{1..4} )

inherit distutils-r1 pypi

HOMEPAGE="https://github.com/jlevy/flowmark"
DESCRIPTION="Better auto-formatting for Markdown and plaintext"
SRC_URI="https://github.com/jlevy/flowmark/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/marko-2.1.3[${PYTHON_USEDEP}]
	>=dev-python/regex-2024.11.6[${PYTHON_USEDEP}]
	>=dev-python/strif-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.12.2[${PYTHON_USEDEP}]"

RESTRICT="test"

## Hack
src_prepare() {
	distutils-r1_src_prepare

	sed -i -e "s/^dynamic = .*/version = \"${PV}\"/g" ${S}/pyproject.toml
	}
