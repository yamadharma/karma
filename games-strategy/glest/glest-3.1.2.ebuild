# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WX_GTK_VER="2.6"

inherit eutils wxwidgets games

L_URI="http://www.glest.org/files/contrib/translations"
DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="http://www.glest.org"
RESTRICT="primaryuri"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.bz2
	mirror://sourceforge/${PN}/${PN}_data_${PV}.zip
	linguas_hu? ( ${L_URI}/magyar_${PV}.zip )
	linguas_pt_BR? ( ${L_URI}/brazilian_${PV}.zip )
	linguas_ru? ( ${L_URI}/russian_${PV}.zip )"

LICENSE="GPL-2 glest-data"
SLOT="0"
KEYWORDS="amd64 -ppc x86" # ppc: bug #145478
IUSE="debug linguas_hu linguas_pt_BR linguas_ru"

DEPEND="media-libs/libvorbis
	media-libs/libogg
	>=media-libs/libsdl-1.2.5
	media-libs/openal
	dev-libs/xerces-c
	dev-util/ftjam
	>=virtual/opengl-1.3
	>=virtual/glu-1.3
	app-arch/unzip
	=x11-libs/wxGTK-2.6*
	x11-libs/libX11
	x11-libs/libXt"

# I add block to ati-drivers version below 8.493, because these
# versions has segfaults when running the glest.
RDEPEND="!<x11-drivers/ati-drivers-8.493"

SOURCE_PATH="${WORKDIR}"/"${PN}"-source-"${PV}"

src_unpack() {
	unpack ${A}
	cd "${SOURCE_PATH}"

	epatch "${FILESDIR}/${P}-screen.patch"
	epatch "${FILESDIR}/${P}-home.patch"
	epatch "${FILESDIR}/${P}-includes.patch"	
}

src_compile() {
	cd "${SOURCE_PATH}"

#	egamesconf \
	econf \
		$(use_enable debug) \
		|| die
	jam || die "jam failed"
}

src_install() {
	cd "${SOURCE_PATH}"
	dogamesbin glest || die "dogamesbin glest failed"
	dogamesbin glest_editor || die "dogamesbin glest_editor failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins glest.ini || die "doins glest.ini failed"

	dodoc README.linux || die "dodoc README.linux failed"

	cd "${WORKDIR}"/"${PN}"_game
	doins servers.ini || die "doins servers.ini failed"
	doins glest_irc.url || die "doins glest_irc.url failed"
	doins glest_web.url || die "doins glest_web.url failed"
	doins -r data maps scenarios techs tilesets || die "doins data failed"
	dodoc docs/readme.txt || die "dodoc docs/readme.txt failed"
	
	newicon techs/magitech/factions/magic/units/archmage/images/archmage.bmp \
		${PN}.bmp
	make_desktop_entry glest Glest /usr/share/pixmaps/${PN}.bmp

	dolang() {
		insinto "${GAMES_DATADIR}"/${PN}/data/lang
		doins "${WORKDIR}"/${1} || die "doins ${1} failed"
	}

	use linguas_hu && dolang magyar.lng
	use linguas_ru && dolang russian.lng
	use linguas_pt_BR && dolang brazilian_${PV}.lng

	prepgamesdirs
}

pkg_postinst() {
	elog "Fix the sound problem using the alsa driver in OpenAl. More"
	elog "informations at"
	elog "http://supertux.lethargik.org/wiki/OpenAL_Configuration"
	echo
	elog "If you want play multiplayer glest use the official"
	elog "binaries."
	echo
}
