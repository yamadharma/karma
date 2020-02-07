# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Simple Python module providing rate limiting"
HOMEPAGE="https://pypi.python.org/pypi/ratelimiter"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.post0.tar.gz"

LICENSE="Apache"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S=${WORKDIR}/${P}.post0

RDEPEND="
    dev-python/appdirs[${PYTHON_USEDEP}]
    dev-python/ratelimiter[${PYTHON_USEDEP}]
    dev-python/configargparse[${PYTHON_USEDEP}]
    dev-python/wrapt[${PYTHON_USEDEP}]
    dev-python/requests[${PYTHON_USEDEP}]
    dev-python/pyyaml[${PYTHON_USEDEP}]
    "