# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Command line client for the self hosted read-it-later app Wallabag"
HOMEPAGE="https://github.com/artur-shaik/wallabag-client"
SRC_URI="https://github.com/artur-shaik/wallabag-client/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}
		dev-python/click-repl[${PYTHON_USEDEP}]
		dev-python/delorean[${PYTHON_USEDEP}]
		dev-python/humanize[${PYTHON_USEDEP}]
		dev-python/yaspin[${PYTHON_USEDEP}]
		dev-python/markdownify[${PYTHON_USEDEP}]
"

src_configure() {
		export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}
