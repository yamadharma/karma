# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Handbrake is multithreaded DVD to MPEG4 ripper/converter."
HOMEPAGE="http://handbrake.m0k.org"
SRC_URI="http://junk.phantomgorilla.com/hb/HandBrake-${PV}.tar.gz"
#http://handbrake.m0k.org/rotation.php?file=HandBrake-${PV}.tar.gz


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-util/jam
		media-libs/a52dec
		media-libs/faac
		media-video/ffmpeg
		media-sound/lame
		media-libs/libdvdcss
		media-libs/libdvdread
		media-libs/libogg
		media-libs/libsamplerate
		media-libs/libvorbis
		media-libs/libmpeg2
		media-video/mpeg4ip
		media-libs/x264-svn
		media-libs/xvid
		x86? ( >=dev-lang/nasm-0.98.36 )
		amd64? ( >=dev-lang/yasm-0.4.0 )"

S=${WORKDIR}/HandBrake

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-configure.patch
	epatch ${FILESDIR}/${P}-jamfile.patch
}


src_compile() {
	cd ${S}
	./configure
	OSPLAT=`echo ${ARCH} | tr a-z A-Z` jam
	mv ${S}/HBTest ${S}/handbrake
}

src_install() {
	cd ${S}
	dobin handbrake
}

