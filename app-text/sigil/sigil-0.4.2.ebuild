# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils cmake-utils fdo-mime


DESCRIPTION="Sigil is a multi-platform WYSIWYG ebook editor. It is designed to
edit books in ePub format."

HOMEPAGE="http://code.google.com/p/sigil"

SRC_URI="http://sigil.googlecode.com/files/Sigil-${PV}-Code.zip"

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

QT_VER="4.7.0"

DEPEND=">=dev-util/cmake-2.8.0"

RDEPEND="
		>=x11-libs/qt-core-${QT_VER}
		>=x11-libs/qt-gui-${QT_VER}
		>=x11-libs/qt-xmlpatterns-${QT_VER}
		>=x11-libs/qt-svg-${QT_VER}
		>=x11-libs/qt-webkit-${QT_VER}
		"


INSTALL_LOCATION="/opt"


S="${WORKDIR}"


src_prepare() {

	mkdir data

	# adapt icons
	for i in 16 32 48 128 256
	do
		mkdir -p data/icons/hicolor/${i}x${i}/apps
		cp src/Sigil/Resource_Files/icon/app_icon_${i}.png data/icons/hicolor/${i}x${i}/apps/sigil.png
	done

}


src_configure() {

	cmake -G "Unix Makefiles" \
		-DCMAKE_INSTALL_PREFIX=${INSTALL_LOCATION} \
		-DCMAKE_BUILD_TYPE=Release \
		${S}
}


src_install() {

	cmake-utils_src_install

	# menu 
	# the folowing is possible for sigil-0.3.4
	# domenu src/Sigil/Resource_Files/freedesktop/sigil.desktop
	domenu ${FILESDIR}/sigil.desktop

	# icons
	insinto /usr/share
	doins -r data/icons

}


pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

}

