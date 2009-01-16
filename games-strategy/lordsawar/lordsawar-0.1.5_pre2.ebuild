# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games

DESCRIPTION="Another Free Warlords II clone"
HOMEPAGE="http://www.lordsawar.com/
	http://www.nongnu.org/lordsawar"
SRC_URI="http://download.savannah.gnu.org/releases/lordsawar/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="editor ggz nls sound zip"

S=${WORKDIR}/${P%%_pre*}

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	dev-cpp/gtkmm
	sound? ( media-libs/sdl-mixer )
	dev-cpp/libglademm
	gzz? ( dev-games/libggz )
	zip? ( app-arch/zip )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_configure() {
	local myconf=""
	if use zip
	then
		ewarn "Ziping saved filegames is still experimental, if you experience \
		some troubles turn zip useflag off."
		myconf+=" --enable-zipping"
	else
		myconf+=" --disable-zipping"
	fi
	egamesconf \
		--disable-dependency-tracking \
		--disable-rpath \
		--disable-sdltest \
		$(use_with sound) \
		$(use_enable nls) \
		$(use_enable gzz) \
		$(use_with ggz ggz-server) \
		$(use_with ggz ggz-client) \
		$(use_enable editor) \
		${myconf} \
		|| die "egamesconf failed"
}

src_install() {
	P_N="freelords"
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon dat/various/${P_N}.png
	make_desktop_entry ${PN} FreeLords
	if use editor ; then
		doicon dat/various/${P_N}_editor.png
		make_desktop_entry ${P_N}_editor "LordsAWar Editor" ${P_N}_editor.png
	fi
	dodoc ChangeLog NEWS TODO README doc/Savefile
	prepgamesdirs
}
