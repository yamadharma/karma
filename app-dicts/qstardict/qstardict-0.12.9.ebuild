# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit qt4

DESCRIPTION="QStarDict is a StarDict clone written in Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
SRC_URI="http://qstardict.ylsoftware.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="dbus nls pronounce"

RDEPEND="dbus? ( || ( x11-libs/qt-gui:4[dbus] <x11-libs/qt-4.4.0:4[dbus] ) )
		!dbus? ( || ( x11-libs/qt-gui:4 <=x11-libs/qt-4.4.0:4 ) )
		pronounce? ( app-dicts/wyabdcrealpeopletts
					media-sound/sox )
		>=dev-libs/glib-2.0"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if use pronounce; then
		sed -e "s:festival --tts:qstardict-pronounce:" \
			-i qstardict/speaker.cpp || die
	fi
	sed -e '/^Categories.*[^;]$/s:$:;:' \
			-i qstardict/qstardict.desktop || die
}

src_compile() {
	local QMAKE_FLAGS="DOCS_DIR=/usr/share/doc/${PF}/"
	use dbus || QMAKE_FLAGS+=" NO_DBUS=1"
	use nls || QMAKE_FLAGS+=" NO_TRANSLATIONS=1"
	# Avoid stripping. TODO: find out why stip gets into Makefiles (it should
	# not be there)
	QMAKE_FLAGS+=" QMAKE_STRIP=true"
	eqmake4 qstardict.pro ${QMAKE_FLAGS}
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install filed"
	if use pronounce; then
		dobin "${FILESDIR}/qstardict-pronounce" || die
	fi
	elog
	elog "There are several possibilities to enable pronouncing of the words:"
	elog " 1. emerge app-accessibility/espeak and use espeak command"
	elog " 2. emerge app-accessibility/festival and use festival --tts command"
	elog " 3. emerge qstardict with USE pronounce and it'll use"
	elog "    app-dicts/wyabdcrealpeopletts words database to and play them with"
	elog "    qstardict-pronounce command"
	elog
}
