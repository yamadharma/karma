# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Jupyter kernel for gnuplot"
HOMEPAGE="https://github.com/has2k1/gnuplot_kerne"
SRC_URI="https://github.com/has2k1/gnuplot_kernel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/metakernel[${PYTHON_USEDEP}]
	sci-visualization/gnuplot
"
DEPEND="${RDEPEND}"
