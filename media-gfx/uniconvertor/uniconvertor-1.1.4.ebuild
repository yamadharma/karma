# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="UniConvertor-${PV}"
inherit distutils

DESCRIPTION="UniConvertor - commandline tool for popular vector formats convertion."
HOMEPAGE="http://sk1project.org/modules.php?name=Products&product=uniconvertor"
SRC_URI="http://sk1project.org/downloads/${PN}/v${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/python"
RDEPEND="${DEPEND}
	dev-python/imaging
	dev-python/reportlab"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
	dosym uniconv /usr/bin/uniconvertor || die
}
