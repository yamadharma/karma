# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/extsizes/extsizes-1.0.ebuild,v 1.7 2007/12/11 10:36:23 aballier Exp $

EAPI=7

inherit latex-package

MY_PN="LinLibertineTex"
MY_P="${MY_PN}-$(ver_cut 1-2 ${PV})beta"

DESCRIPTION="TeX bindings for OpenType fonts from the Linux Libertine Open Fonts Project"
HOMEPAGE="http://linuxlibertine.sourceforge.net/"
SRC_URI="mirror://sourceforge/linuxlibertine/${MY_P}.zip"

LICENSE="|| ( GPL-2 OFL )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="${RDEPEND}
	>=media-fonts/libertine-${PV}"

S="${WORKDIR}"

src_install() {
	cd ${S}
	dodir ${TEXMF}
    	cp -R texmf/* ${D}${TEXMF}
	
	dodoc ${S}/README
	
	# /etc/texmf/updmap.d/90libertine.cfg
	dodir /etc/texmf/updmap.d
	echo "# LOFP - Libertine Open Fonts Project" > ${D}/etc/texmf/updmap.d/90libertine.cfg
	echo "Map libertine.map" >> ${D}/etc/texmf/updmap.d/90libertine.cfg
}
