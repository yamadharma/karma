# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A Jupyter Notebook server extension that implements common Slurm commands"
HOMEPAGE="https://github.com/NERSC/jupyterlab-slurm"
SRC_URI="mirror://pypi/j/jupyterlab_slurm/jupyterlab_slurm-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="\
	sys-cluster/slurm \
	dev-python/notebook[${PYTHON_USEDEP}] \
"

src_unpack() {
	default
        mv * ${P}
}

src_prepare() {
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install --skip-build
	rm ${D}/usr/share/jupyter/lab/extensions/jupyter-slurm-*.tgz
}

python_install_all() {
	distutils-r1_python_install_all
}
