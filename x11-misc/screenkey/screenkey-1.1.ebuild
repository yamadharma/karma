# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A screencast tool to display your keys inspired by Screenflick"
HOMEPAGE="https://gitlab.com/screenkey/screenkey
	https://www.thregr.org/~wavexx/software/screenkey/"
SRC_URI="https://gitlab.com/screenkey/screenkey/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	x11-misc/slop
	media-fonts/fontawesome
"
BDEPEND=""

S="${WORKDIR}/${PN}-v${PV}"
