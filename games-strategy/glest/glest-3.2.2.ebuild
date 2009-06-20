# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/glest/glest-3.1.2.ebuild,v 1.5 2009/01/22 18:53:35 mr_bones_ Exp $

EAPI=2
inherit autotools eutils games

L_URI="http://www.glest.org/files/contrib/translations"
DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="http://www.glest.org/"
SRC_URI="http://www.titusgames.de/${PN}-source-${PV}.tar.bz2
	mirror://sourceforge/${PN}/${PN}_data_3.2.1.zip
	"

LICENSE="GPL-2 glest-data"
SLOT="0"
KEYWORDS="~amd64 -ppc ~x86" # ppc: bug #145478

IUSE="editor"

RDEPEND="|| ( media-libs/libsdl[joystick] <media-libs/libsdl-1.2.13-r1 )
	media-libs/libogg
	media-libs/libvorbis
	media-libs/openal
	dev-libs/xerces-c
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	media-fonts/font-adobe-utopia-75dpi
	editor? ( x11-libs/wxGTK )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/ftjam"

S="${WORKDIR}"/${PN}-source-${PV}

GAMES_USE_SDL="nojoystick"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-{gentoo,xerces-c}.patch

	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		glest_game/main/main.cpp \
		|| die "sed main.cpp failed"

	# sometimes they package configure, sometimes they don't
	if [[ ! -f configure ]] ; then
		chmod a+x autogen.sh
		./autogen.sh || die "autogen failed" # FIXME: use autotools.eclass
	fi

	sed -i 's:-O3 -g3::' Jamrules || die "sed Jamrules failed"
}

src_configure() {
	use editor || NOWX=" --with-wx-config=disabled_wx"
	egamesconf \
		--with-vorbis=/usr \
		--with-ogg=/usr\
		${NOWX}
}

src_compile() {
	jam -q || die "jam failed"
}

src_install() {
	dogamesbin glest || die "dogamesbin glest failed"
	if use editor ; then 
	    dogamesbin glest_editor || die "dogamesbin glest_editor failed"
	fi

	insinto "${GAMES_DATADIR}"/${PN}
	doins glest.ini || die "doins glest.ini failed"
	## dodoc readme_linux.txt || die "dodoc readme_linux.txt failed" no linux readme file

#       seams to be not present
#		glest_irc.url \
#		glest_web.url \
	cd "${WORKDIR}"/glest_game
	doins -r servers.ini \
		data maps scenarios techs tilesets || die "doins data failed"
	dodoc docs/readme.txt || die "dodoc docs/readme.txt failed"

	newicon techs/magitech/factions/magic/units/archmage/images/archmage.bmp \
		${PN}.bmp
	make_desktop_entry glest Glest /usr/share/pixmaps/${PN}.bmp

	dolang() {
		insinto "${GAMES_DATADIR}"/${PN}/data/lang
		doins "${WORKDIR}"/${1} || die "doins ${1} failed"
	}

	prepgamesdirs
}

