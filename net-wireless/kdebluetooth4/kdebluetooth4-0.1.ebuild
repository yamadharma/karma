# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

NEED_KDE="4.1"
inherit kde4overlay-base

DESCRIPTION="KDE Bluetooth Framework"
HOMEPAGE="http://bluetooth.kmobiletools.org/"
SRC_URI="mirror://sourceforge/kde-bluetooth/${P}.tar.bz2"

SLOT="4.1"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""

# Localisation will be added once we have a release.

DEPEND=">=dev-libs/openobex-1.3
	app-mobilephone/obexftp
	app-mobilephone/obex-data-server"

RDEPEND="${DEPEND}
	|| ( ( kde-base/kdialog:${SLOT} kde-base/konqueror:${SLOT} )
		kde-base/kdelibs:${SLOT} )
	kde-base/solid
	>=net-wireless/bluez-libs-3.11
	>=net-wireless/bluez-utils-3.11"

src_unpack() {
	kde4overlay-base_src_unpack
	cd "${S}"
	rm -f "${S}/configure"
}
