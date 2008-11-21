# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://code.gns3.net/hgwebdir.cgi/gns3-overlay/summary

inherit python multilib distutils

DESCRIPTION="Dynamips Configuration Generator"
HOMEPAGE="http://dyna-gen.sourceforge.net/"
SRC_URI="mirror://sourceforge/dyna-gen/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-emulation/dynamips"

src_unpack() {
	distutils_src_unpack
	epatch ${FILESDIR}/01_all_setup.py.patch
	sed -i -e "s/__VERSION__/${PV}/g" setup.py || die
}

src_install() {
	distutils_src_install	

	# configspec for net file-format
	insinto /usr/share/${PN}
	doins configspec
	
	insinto /etc
	doins dynagen.ini
	
	dodoc README.txt COPYING
	dohtml -r docs/*
	docinto examples/sample_labs/
	dodoc sample_labs/*
}

pkg_postinst() {
	elog "See /usr/share/doc/${P} for more information,"
	elog "or read the tutorial in /usr/share/doc/${P}/html/"
}
