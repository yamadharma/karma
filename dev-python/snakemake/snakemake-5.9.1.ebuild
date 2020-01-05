# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Make-like task language"
HOMEPAGE="https://snakemake.readthedocs.io"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
    dev-python/appdirs[${PYTHON_USEDEP}]
    dev-python/ratelimiter[${PYTHON_USEDEP}]
    dev-python/configargparse[${PYTHON_USEDEP}]
    dev-python/wrapt[${PYTHON_USEDEP}]
    dev-python/requests[${PYTHON_USEDEP}]
    dev-python/pyyaml[${PYTHON_USEDEP}]
    "