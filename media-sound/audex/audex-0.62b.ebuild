# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit kde4-base

DESCRIPTION="audex is a new audio grabber tool based on KDE 4"
HOMEPAGE="http://opensource.maniatek.de/audex"
SRC_URI="http://opensource.maniatek.de/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-sound/cdparanoia
	>=kde-base/libkcddb-${KDE_MINIMAL}
	>=kde-base/libkcompactdisc-${KDE_MINIMAL}"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-include.patch"
	
	kde4-base_src_prepare
}
