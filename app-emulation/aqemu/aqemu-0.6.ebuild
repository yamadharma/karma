# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="AQEMU is a graphical interface to QEMU emulator. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	doc? ( linguas_ru? ( http://downloads.sourceforge.net/${PN}/AQEMU-${PV}-Doc-RU.tar.bz2 ) )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc kvm linguas_ru"

DEPEND="${RDEPEND}"
RDEPEND=">=x11-libs/qt-4.2.3-r1
         kvm? ( app-emulation/kvm )
         !kvm? ( >=app-emulation/qemu-0.9.0 )
         >=media-libs/libpng-1.2.16
         >=dev-libs/libxml2-2.6.27"

src_compile() {
	qmake AQEMU.pro
	make
}

src_install() {
	newbin AQEMU aqemu

	insinto /usr/share/aqemu
	if use linguas_ru
	then
		doins Russian.qm
	fi

	insinto /usr/share/aqemu/os_icons
	doins ./os_icons/*

	insinto /usr/share/aqemu/os_templates/
	doins ./os_templates/*

	insinto /usr/share/applications/
	doins ./menu_data/aqemu.desktop || die "Cannot create aqemu application link!"

	insinto /usr/share/menu/
	doins ./menu_data/aqemu || die "Cannot create aqemu menu item!"

	insinto /usr/share/pixmaps/
	doins ./menu_data/*.png || die "Cannot copy AQEMU pixmaps!"

	if ( use doc )
	then
	    if ( use linguas_ru )
	    then
		dohtml -r ${WORKDIR}/AQEMU-${PV}-Doc-RU
	    fi
	fi
}

pkg_postinst() {
	echo
	elog "Files VM versions below 0.5 are NOT supported!"
	elog "When you upgrade from version 0.5 or above, simply"
	elog "click Apply for each VM to keep it in the new version."
	echo
}
