# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.8.1.ebuild,v 1.8 2008/03/21 06:18:04 drac Exp $

EAPI=""

inherit eutils gnome2-utils

MY_PV=${PV/rc/RC}
MY_PV1=${PV/rc?/RC}
DESCRIPTION="Mac OS X theme for Gnome enviroment"
HOMEPAGE="http://sourceforge.net/projects/mac4lin/"
SRC_URI="mirror://sourceforge/mac4lin/Mac4Lin_v${MY_PV}.tar.gz
		 mirror://sourceforge/mac4lin/Leopard_Wallpapers.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="amd64 x86"

S=${WORKDIR}/Mac4Lin_v${MY_PV}

IUSE="awn grub emerald"

RESTRICT="binchecks strip"

RDEPEND=">=x11-misc/icon-naming-utils-0.8.2
	media-gfx/imagemagick
	>=gnome-base/librsvg-2.12.3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_install() {
	dodir /usr/share/pixmaps/backgrounds/osx
	insinto /usr/share/pixmaps/backgrounds/osx
	doins ${WORKDIR}/Leopard_Wallpapers/*
	doins ${WORKDIR}/Mac4Lin_v${MY_PV}/Wallpapers/*

	dodir /usr/share/themes
	cd ${S}/GTK
	for gtk_tarball in *.tar.gz
	do
		tar -xf "${gtk_tarball}" -C "${D}"/usr/share/themes
	done

	dodir /usr/share/icons
	cd ${WORKDIR}/Mac4Lin_v${MY_PV}/Icons
	tar -xf "Mac4Lin_Icons_v${MY_PV1}.tar.gz" -C "${D}"/usr/share/icons
	cd ${S}/Cursors
	tar -xf "Mac4Lin_Cursors_v${MY_PV1}.tar.gz" -C "${D}"/usr/share/icons

	cd ${S}
	einfo "Installing Mac4Lin GDM Login Theme and Sounds..."
	dodir /usr/share/gdm/themes
	tar -xzf GDM/Mac4Lin_GDM_v${MY_PV1}.tar.gz -C ${D}/usr/share/gdm/themes/
	mv ${D}/usr/share/gdm/themes/Mac4Lin_GDM_v${MY_PV1} ${D}/usr/share/gdm/themes/Mac4Lin
	dodir /usr/share/sounds
	tar -xzf Sounds/Mac4Lin_Sounds_v${MY_PV1}.tar.gz -C  ${D}/usr/share/sounds/
	tar -xzf Sounds/Mac4Lin_Pidgin-Sounds_v${MY_PV1}.tar.gz -C  ${D}/usr/share/sounds/

	# Hacks
	chmod -R a+r ${D}/usr/share/
	chmod -R o-w ${D}/usr/share/
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

