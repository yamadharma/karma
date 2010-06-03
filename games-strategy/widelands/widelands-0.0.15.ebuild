# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils versionator games cmake-utils

MY_PV=$(get_version_component_range 3)
DESCRIPTION="A game similar to Settlers 2"
HOMEPAGE="http://www.widelands.org/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/build-${MY_PV}/widelands-build${MY_PV}-src.tar.bz2
	http://launchpad.net/widelands/build${MY_PV}/build${MY_PV}/+download/widelands-build${MY_PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/sdl-gfx
	media-libs/libpng
	dev-libs/boost
	dev-games/ggz-client-libs"

S=${WORKDIR}/${PN}-build15-src

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-gcc45-fix.patch

	sed -i \
		-e 's:__ppc__:__PPC__:' src/s2map.cc \
		|| die "sed s2map.cc failed"
}

src_configure() {
	mycmakeargs+=( -DWL_VERSION_STANDARD=true
	-DWL_INSTALL_PREFIX=/usr
	-DWL_INSTALL_BINDIR=${GAMES_BINDIR} )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon pics/wl-ico-128.png ${PN}.png
	make_desktop_entry ${PN} Widelands

	dodoc ChangeLog CREDITS
	prepgamesdirs
}
