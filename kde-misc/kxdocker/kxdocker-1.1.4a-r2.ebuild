# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="KXDocker is the KDE animated docker, supports plugins and notifications"
HOMEPAGE="http://www.xiaprojects.com/www/prodotti/kxdocker/main.php"
SRC_URI="http://www.xiaprojects.com/www/downloads/files/kxdocker/1.0.0/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls bluetooth net arts"

PDEPEND="nls? ( kde-misc/kxdocker-i18n )
	kde-misc/kxdocker-resources
	bluetooth? ( >=kde-misc/kxdocker-bluetooth-1.0.0 )
	net? ( >=kde-misc/kxdocker-networker-1.0.0
		>=kde-misc/kxdocker-gnetio-1.0.0
		>=kde-misc/kxdocker-gipcontrack-1.0.0
		>=kde-misc/kxdocker-arpmanager-1.0.0
		>=kde-misc/kxdocker-gpipe-1.0.0 )
	>=kde-misc/kxdocker-trayiconlogger-1.0.0
	>=kde-misc/kxdocker-dcop-1.0.0
	>=kde-misc/kxdocker-thememanager-1.0.0
	>=kde-misc/kxdocker-configurator-1.0.0
	>=kde-misc/kxdocker-taskmanager-1.0.0
	>=kde-misc/kxdocker-mountmanager-1.0.0"

# List of needed plugins (to run kxdocker)
#kde-misc/kxdocker-resources-1.0.0
#kde-misc/kxdocker-trayiconlogger-1.0.0
#kde-misc/kxdocker-dcop-1.0.0
#kde-misc/kxdocker-thememanager-1.0.0
#kde-misc/kxdocker-configurator-1.0.0
#kde-misc/kxdocker-taskmanager-1.0.0
#kde-misc/kxdocker-mountmanager-1.0.0
#
#
# List of optional/aviable plugins
#kde-misc/kxdocker-i18n ~amd64
#kde-misc/kxdocker-wizard-1.0.0
#kde-misc/kxdocker-arpmanager-1.0.0
#kde-misc/kxdocker-gipcontrack-1.0.0
#kde-misc/kxdocker-gmount-1.0.0
#kde-misc/kxdocker-gnetio-1.0.0
#kde-misc/kxdocker-gpipe-1.0.0
#kde-misc/kxdocker-networker-1.0.0
#kde-misc/kxdocker-gamarok ~amd64
#kde-misc/kxdocker-gaclock ~amd64
#kde-misc/kxdocker-gapager ~amd64
#kde-misc/kxdocker-gbattery ~amd64
#kde-misc/kxdocker-gdate ~amd64
#kde-misc/kxdocker-gmail ~amd64
#kde-misc/kxdocker-bluetooth ~amd64
#kde-misc/kxdocker-gthrottle ~amd64
#kde-misc/kxdocker-gtrash ~amd64

need-kde 3.2

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/kxdocker-1.1.4a-quinnstorm.patch"
}

src_compile() {
	econf `use_with arts` || die "econf failed"
	emake -j1 || die "emake failed"
}

pkg_postinst() {
	einfo "Kxdocker installation is complete,"
	einfo "have a look in kde-misc/kxdocker-<plugin name> for optional plugins."
	einfo ""
}
