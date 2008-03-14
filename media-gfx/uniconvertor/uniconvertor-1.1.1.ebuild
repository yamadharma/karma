# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ Ilya Kashirin (seclorum@seclorum.ru)

NEED_PYTHON=2.4

inherit distutils

KEYWORDS="x86 amd64"

DESCRIPTION="UniConvertor - commandline tool for popular vector formats convertion."
HOMEPAGE="http://sk1project.org/modules.php?name=Products&product=uniconvertor"
SRC_URI="http://sk1project.org/downloads/uniconvertor/v${PV}/${PN}-${PV}.tar.gz"
LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"

DEPEND="virtual/python"
RDEPEND="dev-python/imaging"
S=${WORKDIR}/UniConvertor-${PV}

pkg_postinst() {
	einfo "Run uniconv in console."
}