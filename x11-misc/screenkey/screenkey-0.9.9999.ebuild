# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A screencast tool to display your keys inspired by Screenflick"
HOMEPAGE="https://gitlab.com/wavexx/screenkey"
if [[ ${PV} = *.9999* ]]
then
    inherit git-r3
    EGIT_REPO_URI="https://gitlab.com/wavexx/screenkey.git"
    KEYWORDS="amd64 ~x86"
else
    SRC_URI="https://github.com/wavexx/screenkey/archive/${P}.tar.gz"
    KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
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

# S="${WORKDIR}/${PN}-${P}"
