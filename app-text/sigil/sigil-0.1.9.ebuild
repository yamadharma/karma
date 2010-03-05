# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

MY_P="Sigil-${PV}-Code"
DESCRIPTION="A WYSIWYG ebook editor"
HOMEPAGE="http://code.google.com/p/sigil/"
SRC_URI="http://sigil.googlecode.com/files/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=x11-libs/qt-webkit-4.5:4
	>=x11-libs/qt-svg-4.5:4"
RDEPEND="${DEPEND}
	app-text/htmltidy"

#S="${WORKDIR}/${MY_P}/src/Sigil"
S="${WORKDIR}/${MY_P}"

src_install() {
	cmake-utils_src_install

	cd "${WORKDIR}/${MY_P}"
	dodoc ChangeLog.txt README.txt
}
