# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Author: Andrey Rijov (aka RDron) <ANDron142@yandex.ru>
# KVM Patch By: themixa
# EAPI=2 Patch By: slepnoga <slepnoga@inbox.ru>

EAPI=2
inherit qt4

DOC_PV=0.6.1

DESCRIPTION="Graphical interface for QEMU and KVM. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="kvm linguas_ru qt-static embedded-display"

SRC_URI="
	!qt-static? ( http://downloads.sourceforge.net/aqemu/AQEMU-${PV/_alpha/-Alpha}.tar.bz2 )
	doc? ( linguas_ru? ( http://downloads.sourceforge.net/${PN}/AQEMU-${DOC_PV}-Doc-RU.tar.bz2 ) )"

DEPEND="${RDEPEND}"
RDEPEND="!qt-static? ( >=x11-libs/qt-gui-4.4.2 >=x11-libs/qt-test-4.4.2 )
         kvm? ( app-emulation/kvm )
         !kvm? ( >=app-emulation/qemu-0.9.0 )
		 embedded-display? ( >=net-libs/libvncserver-0.9 )
         >=media-libs/libpng-1.2.16
         >=dev-libs/libxml2-2.6.27"

RESTRICT="nomirror"

S=${WORKDIR}/AQEMU-${PV/_alpha/-Alpha}

src_compile() {
	if use !qt-static; then
		
		if use embedded-display; then
			eqmake4 AQEMU.pro
		else
			eqmake4 AQEMU_Without_VNC.pro
		fi

		emake || die " emake failed!"
	fi
}

src_install() {
	if use !qt-static; then
		
		newbin AQEMU aqemu
		
		dodir /usr/share/aqemu
		insinto /usr/share/aqemu
		
		if use linguas_ru
		then
			doins Russian.qm
		fi
		
		doins aqemu_links.html
		
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
		
		doins ./share/aqemu/aqemu_links.html
		
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
		doins ./share/doc/aqemu/*.bz2
	fi
}

pkg_postinst() {
	echo
	elog "When you upgrade from version 0.5 or above, simply"
	elog "click Apply for each VM to keep it in the new version."
	echo
}
