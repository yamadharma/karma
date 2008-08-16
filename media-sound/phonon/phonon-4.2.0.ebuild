# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
HOMEPAGE="http://phonon.kde.org"
inherit cmake-utils

DESCRIPTION="KDE multimedia API"
KEYWORDS="amd64 x86"
IUSE="debug gstreamer"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.bz2"
SLOT="0"

LICENSE="GPL-2"

RDEPEND="!kde-base/phonon:kde-svn
	!x11-libs/qt-phonon:4
	>=x11-libs/qt-test-4.4.0:4
	>=x11-libs/qt-dbus-4.4.0:4
	>=x11-libs/qt-gui-4.4.0:4
	gstreamer? ( media-libs/gstreamer
		media-libs/gst-plugins-base
		>=x11-libs/qt-opengl-4.4.0:4 )"
DEPEND="${RDEPEND}
	kde-base/automoc"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with gstreamer GStreamer)
		$(cmake-utils_use_with gstreamer GStreamerPlugins)"
	cmake-utils_src_compile
}
