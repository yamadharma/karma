# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Simulation of Urban MObility"
HOMEPAGE="https://github.com/eclipse/sumo"
SRC_URI="https://github.com/eclipse/sumo/archive/refs/tags/v${PV//./_}.tar.gz -> ${P}.tar.gz"
 
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
 
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/${PN}-${PV//./_}

src_configure() {
	local mycmakeargs=(
	-DFOX_CONFIG=/usr/bin/fox-1.6-config
	)

	cmake_src_configure
}

src_install () {
	cmake_src_install

	insinto /usr/share/pixmaps/
	newins ${S}/data/logo/sumo-128x138.png sumo.png
	insinto /usr/share/applications
	doins ${FILESDIR}/${PN}.desktop

}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
