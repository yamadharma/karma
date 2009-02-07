# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Graphical interface for QEMU emulator. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc kvm linguas_ru bindist"

SRC_URI="!bindist? ( http://downloads.sourceforge.net/aqemu/aqemu-${PV}.tar.bz2 )
          bindist? ( http://downloads.sourceforge.net/aqemu/aqemu-${PV}-bin-static-qt-linux.tar.bz2 )
	doc? ( linguas_ru? ( http://downloads.sourceforge.net/${PN}/AQEMU-${PV}-Doc-RU.tar.bz2 ) )"

DEPEND="${RDEPEND}"
RDEPEND="!bindist? ( >=x11-libs/qt-4.2.3-r1 )
         kvm? ( app-emulation/kvm )
         !kvm? ( >=app-emulation/qemu-0.9.0 )
         >=media-libs/libpng-1.2.16
         >=dev-libs/libxml2-2.6.27"

RESTRICT="nomirror"

src_compile() {
	if use !bindist; then
		cd ${WORKDIR}"/aqemu-${PV}"
		qmake AQEMU.pro
		make
	else
		if use amd64
		then
			die "Static Qt4 Build is Only for 32Bit Systems!"
		fi
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
	fi
}

pkg_postinst() {
	echo
	elog "Files VM versions below 0.5 are NOT supported!"
	elog "When you upgrade from version 0.5 or above, simply"
	elog "click Apply for each VM to keep it in the new version."
	echo
}
