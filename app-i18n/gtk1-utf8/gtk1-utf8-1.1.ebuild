# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Fix for GTK1+ && ru_RU.UTF8"
HOMEPAGE="http://wiki.fantoo.ru/index.php/HOWTO_GTK1_with_UTF8"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

RDEPEND=">=x11-libs/gtk+-1.2.10-r11 x11-base/xorg-x11 media-fonts/terminus-font"
DEPEND="${RDEPEND}"

src_install() {
	dodir /usr/share/X11/locale/ru_RU.UTF-8
	insinto /usr/share/X11/locale/ru_RU.UTF-8/
	doins ${FILESDIR}/XLC_LOCALE
	doins ${FILESDIR}/XI18N_OBJS
	doins ${FILESDIR}/Compose

	insinto /etc/gtk
	doins ${FILESDIR}/gtkrc.ru_RU.utf-8

	einfo "Please, read documentation here"
	einfo "http://wiki.fantoo.ru/index.php/HOWTO_GTK1_with_UTF8"
}

pkg_postinst() {
    perl -pi -e 's|en_US.UTF-8/Compose\s+ru_RU.UTF-8|ru_RU.UTF-8/Compose		ru_RU.UTF-8|' /usr/share/X11/locale/compose.dir
    perl -pi -e 's|en_US.UTF-8/Compose:\s+ru_RU.UTF-8|ru_RU.UTF-8/Compose:		ru_RU.UTF-8|' /usr/share/X11/locale/compose.dir
    perl -pi -e 's|en_US.UTF-8/XLC_LOCALE\s+ru_RU.UTF-8|ru_RU.UTF-8/XLC_LOCALE			ru_RU.UTF-8|' /usr/share/X11/locale/locale.dir
    perl -pi -e 's|en_US.UTF-8/XLC_LOCALE:\s+ru_RU.UTF-8|ru_RU.UTF-8/XLC_LOCALE:			ru_RU.UTF-8|' /usr/share/X11/locale/locale.dir
}
