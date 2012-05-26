# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils games

MY_PN="Wolf4SDL"
GAMES=()

DESCRIPTION="Port of Wolfenstein 3D (and Spear of Destiny) for SDL"
HOMEPAGE="http://www.stud.uni-karlsruhe.de/~uvaue/chaos/"
SRC_URI="http://www.stud.uni-karlsruhe.de/~uvaue/chaos/bins/Wolf4SDL-${PV}-src.zip
	http://www.alice-dsl.net/mkroll/bins/Wolf4SDL-${PV}-src.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="smooth strafe spear_demo spear_full wolf3d_apogee wolf3d_id +wolf3d_shareware"

# joystick support is required for compilation; can this be patched out?
DEPEND="media-libs/libsdl[joystick]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}-src"

RESTRICT=mirror

pkg_setup() {
	# Validate USE flags
	if (use wolf3d_shareware && use wolf3d_apogee) \
		|| (use wolf3d_shareware && use wolf3d_id) \
		|| (use wolf3d_apogee && use wolf3d_id); then
		die "You must specify the USE flag for only one version of Wolfenstein 3d."
	elif use spear_demo && use spear_full; then
		die "You must specify the USE flag for only one version of Spear of Destiny."
	elif ! use wolf3d_shareware && ! use wolf3d_apogee && ! use wolf3d_id \
		&& ! use spear_demo && ! use spear_full; then
		die "You must specify the USE flag for your version of Wolfenstein 3D or Spear of Destiny."
	elif use smooth && ! use strafe; then
		die "You must enable the strafe USE flag in order to use smooth."
	fi

	# Determine game version(s) to be installed
	if use wolf3d_shareware || use wolf3d_apogee || use wolf3d_id; then
		GAMES[${#GAMES[*]}]=wolf3d
	fi
	if use spear_demo || use spear_full; then
		GAMES[${#GAMES[*]}]=spear
	fi
}

src_unpack() {
	for GAME in ${GAMES[@]}; do
		unpack ${A}
		mv "${S}" "${WORKDIR}/${GAME}"
	done
}

src_prepare() {
	for GAME in ${GAMES[@]}; do
		cd "${WORKDIR}/${GAME}"

		# Wolf4SDL must be compiled based on version of game data
		# Use USE flags to determine version, with shareware as default
		# Note: In all cases this assumes you're using v1.4 (the final version)
		if [ "${GAME}" == "wolf3d" ]; then
			if use wolf3d_shareware; then
				WOLF3DVER="shareware"
				einfo "Configuring for Wolfenstein 3D $WOLF3DVER version"
				sed -i -e 's;^\(#define GOODTIMES\)\r$;//\1;' \
					-e 's;^//\(#define UPLOAD\)\r$;\1;' version.h \
					|| die "configure version failed"
			elif use wolf3d_apogee; then
				WOLF3DVER="Apogee/3D Realms"
				einfo "Configuring for Wolfenstein 3D $WOLF3DVER version"
				sed -i -e 's;^\(#define GOODTIMES\)\r$;//\1;' version.h \
					|| die "configure Wolfenstein 3D version failed"
			elif use wolf3d_id; then
				WOLF3DVER="ID/GT/Activision"
				einfo "Configuring for Wolfenstein 3D $WOLF3DVER version"
			fi
		elif [ "${GAME}" == "spear" ]; then
			if use spear_demo; then
				SPEARVER="demo"
				einfo "Configuring for Spear of Destiny $SPEARVER version"
				sed -i -e 's;^\(#define GOODTIMES\)\r$;//\1;' \
					-e 's;^//\(#define SPEAR\)$;\1;' \
					-e 's;^//\(#define SPEARDEMO\)\r$;\1;' version.h \
					|| die "configure version failed"
			elif use spear_full; then
				SPEARVER="full"
				einfo "Configuring for Spear of Destiny $SPEARVER version"
				sed -i -e 's;^\(#define GOODTIMES\)\r$;//\1;' \
					-e 's;^//\(#define SPEAR\)\r$;\1;' version.h \
					|| die "configure version failed"
			fi
		fi

		# Apply patch to fix Linux compilation and support per-user configs
		epatch "${FILESDIR}/linuxfix.patch" \
			|| die "linuxfix patch failed"

		# Apply patch to support auto-grabbing mouse in window mode
		epatch "${FILESDIR}/windowmouse.patch" \
			|| die "window mouse patch failed"

		# Apply patch to provide quake-style strafing
		if use strafe; then
			epatch "${FILESDIR}/strafe.patch" \
				|| die "strafe patch failed"

			# Apply patch to smooth gameplay experience, particularly mouse control
			if use smooth; then
				epatch "${FILESDIR}/smooth.patch" \
				|| die "smooth patch failed"
			fi
		fi
	done
}

src_compile() {
	for GAME in ${GAMES[@]}; do
		cd "${WORKDIR}/${GAME}"
		emake || die "could not build ${GAME}"
	done
}

src_install() {
	for GAME in ${GAMES[@]}; do
		cd "${WORKDIR}/${GAME}"
		[ "${GAME}" == "spear" ] && mv wolf3d ${GAME}

		insinto "${GAMES_DATADIR}/${PN}/${GAME}"
		exeinto "${GAMES_DATADIR}/${PN}/${GAME}" || die "${GAME} binary installation failed"
		doexe ${GAME}
		games_make_wrapper ${GAME} "${GAMES_DATADIR}/${PN}/${GAME}/${GAME}" "${GAMES_DATADIR}/${PN}/${GAME}"

		doicon "${FILESDIR}/${GAME}.png"
		if [ "${GAME}" == "wolf3d" ]; then
			make_desktop_entry ${GAME} "Wolfenstein 3D (${MY_PN})" ${GAME}
		elif [ "${GAME}" == "spear" ]; then
			make_desktop_entry ${GAME} "Spear of Destiny (${MY_PN})" ${GAME}
		fi
	done

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn

	for GAME in ${GAMES[@]}; do
		if [ ${GAME} == 'wolf3d' ]; then
			local NAME="Wolfenstein 3D"
			local VER=$WOLF3DVER
		elif [ ${GAME} == 'spear' ]; then
			local NAME="Spear of Destiny"
			local VER=$SPEARVER
		fi
		ewarn "Note: You must copy your ${NAME} game data files for the"
		ewarn "${VER} version to: ${GAMES_DATADIR}/${PN}/${GAME}"
		ewarn
	done

	ewarn "Tip: Before running the game, use ' --help' to get info info"
	ewarn "regarding resolution and fullscreen settings."
}
