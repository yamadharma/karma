# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Scan Tailor is an interactive post-processing tool for scanned pages"
HOMEPAGE="http://scantailor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/boost
	media-libs/jpeg
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	x11-libs/libXrender
	>=x11-libs/qt-gui-4.4
	"

DEPEND="$RDEPEND"

src_install() {
	cmake-utils_src_install

	newicon "${S}"/resources/appicon.svg scantailor.svg
	make_desktop_entry scantailor "Scan Tailor"
}
