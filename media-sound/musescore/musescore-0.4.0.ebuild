# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musescore/musescore-0.0.6.ebuild,v 1.10 2004/12/19 06:11:34 eradicator Exp $

IUSE="fluidsynth jack"

#inherit kde eutils qt4 font
inherit eutils font

MY_P=mscore-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Music Score Typesetter"
HOMEPAGE="http://muse.seh.de/mscore/index.php"
SRC_URI="mirror://sourceforge/mscore/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=">=x11-libs/qt-4.2
	>=dev-util/cmake-2.4
	fluidsynth?	( >=media-sound/fluidsynth-0.9.0 )
	jack?		( >=media-sound/jack-audio-connection-kit-0.98.0 )"

BUILDDIR="${S}/build"

FONT_SUFFIX="otf"
FONT_S=${S}/mscore/mscore/fonts

src_compile() {
	local CMAKE_VARIABLES=""

	mkdir "${BUILDDIR}" || die "Failed to generate build directory"

	addwrite "${QTDIR}/etc/settings"

	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_INSTALL_PREFIX:PATH=/usr"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_BUILD_TYPE=RELEASE"

	cd "${BUILDDIR}"
	
	cmake ${CMAKE_VARIABLES} ../mscore \
		|| die "cmake configuration failed"

	emake || die "make failed"
}

src_install() {
	cd "${BUILDDIR}"
	make DESTDIR="${D}" install || die "make install failed."

	font_src_install

	cd ${S}/mscore
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TODO doc/README.translate doc/MANUAL
}
