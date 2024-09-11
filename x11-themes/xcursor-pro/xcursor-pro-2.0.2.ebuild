# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Modern XCursors"
HOMEPAGE="https://github.com/ful1e5/XCursor-pro"
SRC_URI="https://github.com/ful1e5/XCursor-pro/releases/download/v${PV}/xcursor-pro-all.tar.xz -> ${P}.tar.xz"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	dodir /usr/share/cursors/xorg-x11
	cp -R XCursor-Pro-* ${D}/usr/share/cursors/xorg-x11/
}
