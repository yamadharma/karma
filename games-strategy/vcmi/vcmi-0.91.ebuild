# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# inherit autotools flag-o-matic
inherit cmake-utils

MY_PV=${PV/./}

if [ ${PV##*.} == 9999 ]
then
	inherit subversion
	ESVN_REPO_URI="https://vcmi.svn.sourceforge.net/svnroot/vcmi/trunk/"
	MY_PV=${PV%.*}
	SRC_URI="mirror://sourceforge/${PN}/${PN}_${MY_PV}.zip"
else
	SRC_URI="
	http://download.vcmi.eu/${PN}-${PV}.tar.gz
	http://download.vcmi.eu/core.zip
	http://download.vcmi.eu/WoG/wog.zip
	"
#	mirror://sourceforge/${PN}/${PN}_${MY_PV}.zip
#	http://download.vcmi.eu/mods/cove.zip
#	http://download.vcmi.eu/mods/new-menu.zip
#	http://download.vcmi.eu/mods/witchking-arts.rar
fi

DESCRIPTION="VCMI Project - Heroes 3: WoG recreated"

HOMEPAGE="http://vcmi.sf.net"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"

IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/sdl-ttf
	sys-libs/zlib
	virtual/ffmpeg
	dev-libs/boost"

RESTRICT=mirror

RDEPEND="${DEPEND}"

src_unpack() {
		if [ ${PV##*.} == 9999 ]
		then
			subversion_src_unpack
		fi
		unpack ${A}
}

#src_prepare() {
#		eautoreconf
#}

#src_configure() {
#		append-ldflags -lboost_filesystem
#		econf --datadir=/usr/share/games || die
#		mkdir ${WORKDIR}/build && cd ${WORKDIR}/build
#		cmake ${S}	    
#}

src_install() {
		cmake-utils_src_install
		cd ${S}
		dodoc AUTHORS COPYING ChangeLog NEWS README* vcmimanual.tex

		dodir /usr/share/${PN}
		cd ${WORKDIR}
#		mv sprites ${D}/usr/share/games/${PN}/Sprites
#		mv Data ${D}/usr/share/games/${PN}/Data
#		mv Fonts Games ${D}/usr/share/games/${PN}
#		mv MP3 Maps config ${D}/usr/share/games/${PN}
		cp -Rf Mods ${D}/usr/share/${PN}

		keepdir /usr/share/vcmi/Games
}
