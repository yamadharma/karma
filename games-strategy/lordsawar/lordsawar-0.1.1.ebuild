# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/freelords/freelords-0.3.8.ebuild,v 1.2 2007/05/29 17:00:02 nyhm Exp $

inherit eutils games

DESCRIPTION="Another Free Warlords clone"
HOMEPAGE="http://www.lordsawar.com/"
SRC_URI="http://download.savannah.gnu.org/releases/lordsawar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="editor ggz nls sound"

RDEPEND=">=dev-cpp/gtkmm-2.4
	>=dev-cpp/libglademm-2.4
	media-libs/sdl-image
	ggz? ( dev-games/libggz )
	sound? ( media-libs/sdl-mixer )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

#src_unpack() {
#	unpack ${A}
#	cd "${S}"
#	sed -i \
#		-e '/locale/s:$(datadir):/usr/share:' \
#		-e '/locale/s:$(prefix):/usr:' \
#		-e 's:$(localedir):/usr/share/locale:' \
#		-e '/freelords.desktop/d' \
#		$(find -name 'Makefile.in*') \
#		|| die "sed failed"
#}

src_compile() {
	egamesconf \
		--disable-dependency-tracking \
		--disable-sdltest \
		--disable-winlibs \
		$(use_enable editor) \
		$(use_enable ggz) \
		$(use_with ggz ggz-server) \
		$(use_with ggz ggz-client) \
		$(use_enable nls) \
		$(use_enable sound) \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -f "${D}"/usr/share/locale/locale.alias
	doicon dat/various/${PN}.png
	make_desktop_entry ${PN} FreeLords
	if use editor ; then
		doicon dat/various/${PN}_editor.png
		make_desktop_entry ${PN}_editor "LordsAWar Editor" ${PN}_editor
	fi
	dodoc AUTHORS ChangeLog HACKER NEWS README TODO doc/*.pdf
	prepgamesdirs
}
