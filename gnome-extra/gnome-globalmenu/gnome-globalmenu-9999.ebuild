# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2-utils subversion autotools

ESVN_REPO_URI="http://gnome2-globalmenu.googlecode.com/svn/trunk/"

DESCRIPTION="Global menubar applet for Gnome2."
HOMEPAGE="http://code.google.com/p/gnome2-globalmenu/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/gtk+
	>=x11-libs/libwnck-2.24.1
	>=dev-lang/vala-0.5.5
	>=gnome-base/gnome-panel-2.24.1
	>=gnome-base/gnome-menus-2.24.1"

RDEPEND="${DEPEND}"


src_compile() {
	./autogen.sh --prefix=/usr
}

src_install() {
	addpredict /etc/gconf/gconf.xml.defaults/.testing.writeability
	make DESTDIR="${D}" install || die "make fail"
}

pkg_postinst() {
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to http://gnome2-globalmenu.googlecode.com/issues"
	einfo "Thank you"
}
