# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Matplotlib Jupyter Integration"
HOMEPAGE="https://github.com/matplotlib/ipympl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/ipywidgets-7.5.0[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-4.7[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-2.0.0[${PYTHON_USEDEP}]
"

src_prepare() {
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install --skip-build
	rm ${D}/usr/share/jupyter/lab/extensions/jupyter-matplotlib-*.tgz
}

python_install_all() {
	distutils-r1_python_install_all
}
