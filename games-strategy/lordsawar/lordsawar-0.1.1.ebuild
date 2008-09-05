# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/freelords/freelords-0.3.8.ebuild,v 1.2 2007/05/29 17:00:02 nyhm Exp $

inherit eutils games

DESCRIPTION="Another Free Warlords II clone"
HOMEPAGE="http://www.lordsawar.com/"
SRC_URI="http://download.savannah.gnu.org/releases/lordsawar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="editor ggz nls sound zip"

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	dev-cpp/gtkmm
	sound? ( media-libs/sdl-mixer )
	dev-cpp/libglademm
	gzz? ( dev-games/libggz )
	zip? ( app-arch/zip )"
DEPEND="${RDEPEND}
	nls? (sys-devel/gettext)"

src_compile() {
	if use zip ; then
		ewarn "Ziping saved filegames is still experimental, if you experience \
		some troubles turn zip useflag off."
		ZIP="--enable-zipping"
	else
		ZIP="--disable-zipping"
	fi
	egamesconf \
		--disable-dependency-tracking \
		--disable-rpath \
		--disable-sdltest \
		--disable-winlibs \
		$(use_with sound) \
		$(use_enable nls) \
		$(use_enable gzz) \
		$(use_with ggz ggz-server) \
		$(use_with ggz ggz-client) \
		$(use_enable editor) \
		${ZIP} \
		|| die "egamesconf failed"
	emake || die "emake failed"
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
	dodoc ChangeLog NEWS TODO doc/{Manual,README,Editor,Localization.HOWTO,lordsawarrc}
	elog "see lordsawarrc /usr/share/doc/${PF} for example configuration"
	prepgamesdirs
}

