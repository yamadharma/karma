# Distributed under the terms of the GNU General Public License v2
# Author: Michel Filipe <michel@milk-it.net>
# Date: 2008-05-08

inherit eutils games

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

SOURCE_PATH="${WORKDIR}"/"${PN}"-source-"${PV}"

src_unpack() {
	unpack ${A}
	cd "${SOURCE_PATH}"

	epatch "${FILESDIR}/${P}-screen.patch"
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
	# Install the wrapper file
	cd "${FILESDIR}"
	newgamesbin glest-3.1.2-launcher glest || die "newgamesbin glest failed"

	cd "${SOURCE_PATH}"
	if [ -e glest_editor ]; then
	    dogamesbin glest_editor || die "dogamesbin glest_editor failed"
	fi

	insinto "${GAMES_DATADIR}"/${PN}
	doins glest.ini || die "doins glest.ini failed"
	doins glest || die "dobin glest failed"

	dodoc README.linux || die "dodoc README.linux failed"

	cd "${WORKDIR}"/"${PN}"_game
	doins servers.ini || die "doins servers.ini failed"
	doins glest_irc.url || die "doins glest_irc.url failed"
	doins glest_web.url || die "doins glest_web.url failed"
	doins -r data maps scenarios screens techs tilesets || die "doins data failed"
	dodoc docs/readme.txt || die "dodoc docs/readme.txt failed"
	
	# This is necessary, because the glest binary needs of glest.log for execute
	touch glest.log
	doins glest.log || die "doins glest.log failed"

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

	fperms g+w "${GAMES_DATADIR}/${PN}/glest.log" || die "chmod glest.log failed"

	# Add the execute permission to glest binary
	fperms g+x "${GAMES_DATADIR}"/"${PN}"/glest || die "chmod glest binary failed"
}

pkg_postinst() {
	elog "Fix the sound problem using the alsa driver in OpenAl. More"
	elog "informations at"
	elog "http://supertux.lethargik.org/wiki/OpenAL_Configuration"
	echo
}
