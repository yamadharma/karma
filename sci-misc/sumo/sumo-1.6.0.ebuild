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
 
DEPEND="x11-libs/fox:1.6
	dev-libs/xerces-c
	sci-libs/proj
	sci-libs/gdal
	dev-lang/swig
	virtual/jdk
	dev-cpp/eigen:3
	media-video/ffmpeg
	x11-libs/gl2ps
	dev-lang/python"
RDEPEND="${DEPEND}"
BDEPEND=""

RESTRICT="network-sandbox nostrip"

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

	newenvd - 99sumo <<- EOF || die
	SUMO_HOME="${EPREFIX}/usr/share/sumo"
	EOF
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
