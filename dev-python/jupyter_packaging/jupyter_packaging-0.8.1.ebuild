# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="JupyterLab Server"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~x86"
IUSE=""

