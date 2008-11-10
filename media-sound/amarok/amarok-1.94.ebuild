# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_KDE=":4.2"
inherit kde4-base

DESCRIPTION="Advanced audio player based on KDE framework."
HOMEPAGE="http://amarok.kde.org/"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="4.2"
IUSE="cdaudio daap debug ifp ipod mp3tunes mp4 mtp njb opengl visualization"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.bz2"

# daap are automagic

DEPEND="
	|| ( dev-db/mysql[embedded,-minimal] dev-db/mysql-community[embedded,-minimal] )
	>=app-misc/strigi-0.5.7
	kde-base/kdelibs:${SLOT}
	>=media-libs/taglib-1.5
	|| ( media-sound/phonon x11-libs/qt-phonon:4 )
	x11-libs/qt-webkit:4
	cdaudio? ( kde-base/libkcddb:${SLOT}
		kde-base/libkcompactdisc:${SLOT} )
	ifp? ( media-libs/libifp )
	ipod? ( >=media-libs/libgpod-0.4.2 )
	mp3tunes? ( net-misc/curl
		    dev-libs/libxml2 )
	mp4? ( media-libs/libmp4v2 )
	mtp? ( >=media-libs/libmtp-0.3.0 )
	njb? ( >=media-libs/libnjb-2.2.4 )
	opengl? ( virtual/opengl )
	visualization? ( media-libs/libsdl
		=media-plugins/libvisual-plugins-0.4* )
	"
# 	kde-base/libplasma:${SLOT}

RDEPEND="${DEPEND}
	app-arch/unzip
	daap? ( www-servers/mongrel )
	"

src_configure() {
	if use debug; then
		mycmakeargs="${mycmakeargs} -DCMAKE_BUILD_TYPE=debugfull"
	fi
	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX=${PREFIX}
		-DUSE_SYSTEM_SQLITE=ON
		$(cmake-utils_use_with cdaudio KdeMultimedia)
		$(cmake-utils_use_with ifp Ifp)
		$(cmake-utils_use_with ipod Ipod)
		$(cmake-utils_use_with mp4 Mp4v2)
		$(cmake-utils_use_with mtp Mtp)
		$(cmake-utils_use_with njb Njb)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with visualization Libvisual)
	"
	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	# Dirty hack
	# kde-base/plasma-workspace-4.1.72
	rm ${D}/usr/kde/4.2/lib64/kde4/plasma_animator_default.so
	rm ${D}/usr/kde/4.2/share/kde4/services/plasma-animator-default.desktop
	[ -e /usr/kde/4.2/lib/kde4/plasma_animator_default.so ] && rm ${D}/usr/kde/4.2/lib/kde4/plasma_animator_default.so

	# kde-base/kdelibs-4.1.72
	rm ${D}/usr/kde/4.2/share/kde4/servicetypes/plasma-animator.desktop
	rm ${D}/usr/kde/4.2/share/kde4/servicetypes/plasma-applet.desktop
	rm ${D}/usr/kde/4.2/share/kde4/servicetypes/plasma-containment.desktop
	rm ${D}/usr/kde/4.2/share/kde4/servicetypes/plasma-dataengine.desktop
	rm ${D}/usr/kde/4.2/share/kde4/servicetypes/plasma-runner.desktop
	rm ${D}/usr/kde/4.2/share/kde4/servicetypes/plasma-scriptengine.desktop
}