# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package font

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="http://canopus.iacp.dvo.ru/~panov/cm-unicode/"
SRC_URI="mirror://sourceforge/cm-unicode/${P}-pfb.tar.gz
	mirror://sourceforge/cm-unicode/${P}-otf.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="latex"

FONT_S="${S}"
FONT_SUFFIX="afm pfb otf"
NFONT_SUFFIX="otf"
DOCS="README Changes FAQ TODO Fontmap* INSTALL"

src_install() {
	font_src_install

	if ( use latex )
	then

		latex-package_src_install

		cd ${S}
		insinto ${TEXMF}/fonts/enc/dvips/${PN}
		doins tex/*.enc
		insinto ${TEXMF}/fonts/map/dvips/${PN}
		doins tex/*.enc

		# /etc/texmf/updmap.d/cm-unicode.cfg
		dodir /etc/texmf/updmap.d
		echo "# Computer Modern Unicode fonts" > ${D}/etc/texmf/updmap.d/${PN}.cfg
		echo "Map cmu.map" >> ${D}/etc/texmf/updmap.d/${PN}.cfg
	fi
}

pkg_postinst() {
	font_pkg_postinst
	use latex && latex-package_pkg_postinst
}

pkg_postrm() {
	font_pkg_postrm
	use latex && latex-package_pkg_postrm
}