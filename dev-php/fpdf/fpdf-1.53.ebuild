# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit php-lib-r1 depend.php eutils

DESCRIPTION="FPDF is a PHP class which allows to generate PDF files with pure PHP"
HOMEPAGE="http://www.fpdf.org/"
MY_V="${PV/./}"
MY_P="${PN}${MY_V}"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc"

RESTRICT="fetch"

need_php_by_category

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
		einfo "This source package cannot be automatically downloaded by portage."
		einfo "Point your browser to the URL below and save the downloaded file as"
		einfo "${DISTDIR}/${MY_P}.tgz"
		einfo "to continue."
		einfo ""
		einfo "URL: http://www.fpdf.org/en/dl.php?v=${MY_V}&f=tgz"
}

src_install() {
	php-lib-r1_src_install . *.php *.css font/* font/makefont/*

	dohtml *.htm
	dodoc *.txt 
	use doc && dohtml -r doc tutorial
}
