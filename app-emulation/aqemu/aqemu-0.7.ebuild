# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DOC_PV=0.6.1

DESCRIPTION="Graphical interface for QEMU emulator. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc kvm linguas_ru bindist embedded-display"

SRC_URI="!bindist? ( http://downloads.sourceforge.net/aqemu/aqemu-${PV}.tar.bz2 )
	bindist? 
	(
		x86?   ( http://downloads.sourceforge.net/aqemu/aqemu-${PV}-bin-static-qt-linux-32bit.tar.bz2 )
		amd64? ( http://downloads.sourceforge.net/aqemu/aqemu-${PV}-bin-static-qt-linux-64bit.tar.bz2 )
	)
	doc? ( linguas_ru? ( http://downloads.sourceforge.net/${PN}/AQEMU-${DOC_PV}-Doc-RU.tar.bz2 ) )"

DEPEND="${RDEPEND}"
RDEPEND="!bindist? ( >=x11-libs/qt-4.2.3-r1 )
	kvm? ( app-emulation/kvm )
	!kvm? ( >=app-emulation/qemu-0.9.0 )
	embedded-display? ( >=net-libs/libvncserver-0.9 )
	>=media-libs/libpng-1.2.16
	>=dev-libs/libxml2-2.6.27"



RESTRICT="nomirror"

src_compile() {
	if use !bindist; then
		cd ${WORKDIR}"/aqemu-${PV}"
		
		if use embedded-display; then
			qmake AQEMU.pro
		else
			qmake AQEMU_Without_VNC.pro
		fi

		make
	fi
}

src_install() {
	if use !bindist; then
		cd ${WORKDIR}"/aqemu-${PV}"
		
		newbin AQEMU aqemu
		
		dodir /usr/share/aqemu
		insinto /usr/share/aqemu
		
		if use linguas_ru
		then
			doins Russian.qm
		fi
		
		dodir /usr/share/aqemu/os_icons/
		insinto /usr/share/aqemu/os_icons
		doins ./os_icons/*
		
		dodir /usr/share/aqemu/os_templates/
		insinto /usr/share/aqemu/os_templates/
		doins ./os_templates/*
		
		insinto /usr/share/applications/
		doins ./menu_data/aqemu.desktop
		insinto /usr/share/menu/
		doins ./menu_data/aqemu
		insinto /usr/share/pixmaps/
		doins ./menu_data/*.png
		
		dodoc AUTHORS CHANGELOG README TODO
	else
		cd ${WORKDIR}"/usr"
		newbin ./bin/aqemu aqemu
		
		dodir /usr/share/aqemu
		insinto /usr/share/aqemu
		
		if use linguas_ru
		then
			doins ./share/aqemu/Russian.qm
		fi
		
		dodir /usr/share/aqemu/os_icons/
		insinto /usr/share/aqemu/os_icons
		doins ./share/aqemu/os_icons/*
		
		dodir /usr/share/aqemu/os_templates/
		insinto /usr/share/aqemu/os_templates/
		doins ./share/aqemu/os_templates/*
		
		insinto /usr/share/applications/
		doins ./share/applications/aqemu.desktop
		insinto /usr/share/menu/
		doins ./share/menu/aqemu
		insinto /usr/share/pixmaps/
		doins ./share/pixmaps/*.png
		
		dodir /usr/share/doc/aqemu-${PV}
		insinto /usr/share/doc/aqemu-${PV}
		doins ./share/doc/aqemu-${PV} AUTHORS.bz2 CHANGELOG.bz2 README.bz2 TODO.bz2
	fi
}


pkg_postinst() {
	echo
	elog "Files VM versions below 0.5 are NOT supported!"
	elog "When you upgrade from version 0.5 or above, simply"
	elog "click Apply for each VM to keep it in the new version."
	echo
}
