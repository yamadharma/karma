# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.4

inherit distutils

MY_P="UniConvertor"

KEYWORDS="amd64 x86"
DESCRIPTION="UniConvertor - commandline tool for popular vector formats convertion."
HOMEPAGE="http://sk1project.org/modules.php?name=Products&product=uniconvertor"
SRC_URI="http://sk1project.org/downloads/${PN}/v${PV}/${P}.tar.gz"
LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
IUSE=""

RDEPEND="dev-python/imaging"

S=${WORKDIR}/${MY_P}-${PV}

src_install() {
	# users would like to have same name of package and binary they execute;
	dosym uniconv /usr/bin/${PN}
	distutils_src_install
}
