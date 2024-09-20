# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A cursor theme inspired by the Adwaita icons from the GNOME Project for Windows and Linux with HiDPI support"
HOMEPAGE="https://github.com/ful1e5/notwaita-cursor"
SRC_URI="https://github.com/ful1e5/notwaita-cursor/releases/download/v${PV/_/-}/Notwaita.tar.xz -> ${P}.tar.xz"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	dodir /usr/share/icons
	cp -R Notwaita-* ${D}/usr/share/icons
	for i in Black Gray White
	do	    
	    dosym /usr/share/icons/Notwaita-${i} /usr/share/cursors/xorg-x11/Notwaita-${i}
	done    	    	  	    
}
