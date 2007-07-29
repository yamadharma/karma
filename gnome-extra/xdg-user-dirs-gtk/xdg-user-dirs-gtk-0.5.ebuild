# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="xdg-user-dirs-gtk is a companion to xdg-user-dirs that integrates it into the Gnome desktop and Gtk+ applications"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xdg-user-dirs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=x11-misc/xdg-user-dirs-0.8
	>=x11-libs/gtk+-2"
DEPEND="${RDEPEND}"

DOCS="AUTHOR ChangeLog INSTALL NEWS README"

pkg_postinst() {

	elog
	elog " This package tries to automatically use some sensible default "
	elog " directories for you documents, music, video and other stuff "
	elog
	elog " If you want to change those directories to your needs, see "
	elog " the settings in ~/.config/user-dir.dirs "
	elog

}

