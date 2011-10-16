# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools flag-o-matic

#if [ ${PV} == 9999 ]
#then
	inherit subversion
	ESVN_REPO_URI="https://vcmi.svn.sourceforge.net/svnroot/vcmi/trunk/"
#else
	SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV/./}.zip"
#fi

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
	media-video/ffmpeg
	dev-libs/boost"

RDEPEND="${DEPEND}"

src_unpack() {
		subversion_src_unpack
		unpack ${A}
}

src_prepare() {
		eautoreconf
}

src_configure() {
		append-ldflags -lboost_filesystem
		econf --datadir=/usr/share/games || die
}

src_install() {
		make install DESTDIR=${D} || die
		dodoc INSTALL NEWS README* AUTHORS

		dodir /usr/share/games/${PN}
		cd ${WORKDIR}
		mv sprites ${D}/usr/share/games/${PN}/Sprites
		mv Data ${D}/usr/share/games/${PN}/Data
		mv Fonts Games ${D}/usr/share/games/${PN}
		mv MP3 Maps config ${D}/usr/share/games/${PN}

		keepdir /usr/share/games/vcmi/Games
}
