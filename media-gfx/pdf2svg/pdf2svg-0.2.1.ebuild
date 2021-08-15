# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="7"

inherit eutils

DESCRIPTION="pdf2svg is based on poppler and cairo and can convert pdf to svg files"
HOMEPAGE="http://www.cityinthesky.co.uk/${PN}.html"
SRC_URI="http://www.cityinthesky.co.uk/files/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-text/poppler
	x11-libs/cairo[svg]"
DEPEND="${RDEPEND}"

src_install() {
	dobin ${PN}
}
