# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games

DESCRIPTION="Another Free Warlords II clone"
HOMEPAGE="http://www.lordsawar.com/"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#KEYWORDS=""
IUSE="dedicated editor netplay nls pbm sound"

RDEPEND="dev-libs/boost
	dev-cpp/gtkmm:2.4
	dev-cpp/libglademm
	dev-libs/expat
	dev-libs/libsigc++:2
	dev-libs/libtar
	media-libs/sdl-image
	net-libs/gnet
	nls? ( sys-devel/gettext )
	sound? ( media-libs/sdl-mixer[vorbis] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P/_/-}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--disable-sdltest \
		$(use_enable dedicated ghs) \
		$(use_enable editor) \
		$(use_enable netplay gls) \
		$(use_enable nls) \
		$(use_enable pbm) \
		$(use_enable sound) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	#	rm -f "${D}"/usr/share/locale/locale.alias

	doicon dat/icons/64x64/${PN}.png
	make_desktop_entry ${PN} LordsAWar ${PN}.png

	if use editor ; then
		newicon dat/icons/64x64/${PN}.png ${PN}_editor.png
		make_desktop_entry ${PN}_editor "LordsAWar Editor" ${PN}_editor.png
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"

	prepgamesdirs
}
