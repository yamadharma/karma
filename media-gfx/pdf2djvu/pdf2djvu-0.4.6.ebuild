# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${P/-/_}

DESCRIPTION="PDF to DjVu converter"
HOMEPAGE="http://code.google.com/p/pdf2djvu"
SRC_URI="http://pdf2djvu.googlecode.com/files/${MY_P}.tar.gz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-text/poppler
	app-text/djvu"

DEPEND="${RDEPEND}
	dev-libs/pstreams"


src_install() {
	dobin pdf2djvu
	doman doc/*.1
}
