# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

DESCRIPTION="QtEmu is a graphical user interface for QEMU written in Qt4."
HOMEPAGE="http://qtemu.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RESTRICT="mirror"

DEPEND=">=dev-util/cmake-2.4.3
		>=x11-libs/qt-4.2.2"
RDEPEND="${DEPEND}"

src_compile() {
	# Yes, I definitely want it in /opt.
	mycmakeargs="-DCMAKE_INSTALL_PREFIX=/opt/qtemu"

	cmake-utils_src_configureout
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
	dosym /opt/qtemu/bin/qtemu /usr/bin/qtemu
}
