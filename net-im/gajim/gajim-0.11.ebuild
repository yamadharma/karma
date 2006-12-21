# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.10.1.ebuild,v 1.10 2006/10/05 21:12:41 gustavoz Exp $

inherit virtualx multilib eutils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
SRC_URI="http://www.gajim.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"
IUSE="dbus gnome libnotify nls spell srv"

RDEPEND="!<=dev-python/gnome-python-2
	>=dev-python/pygtk-2.8.2
	>=dev-python/pysqlite-2.0.5
	dbus? ( >=sys-apps/dbus-0.60 )
	gnome? ( >=dev-python/gnome-python-extras-2.10 )
	libnotify? ( x11-misc/notification-daemon )
	srv? ( net-dns/bind-tools )"

DEPEND="dev-util/intltool
	!gnome? ( spell? ( >=app-text/gtkspell-2.0.11 ) )
	input_devices_keyboard? ( x11-libs/libXScrnSaver )"

src_compile() {
	./autogen.sh \
		--enable-idle \
		--enable-trayicon \
		$(use_enable dbus remote) \
		$(use_enable nls) \
		$(use_enable spell gtkspell)
}

src_install() {
	emake PREFIX=/usr DESTDIR=${D} LIBDIR=/$(get_libdir) install || die
	dodoc README AUTHORS COPYING Changelog
}

pkg_postinst() {
	if use x86; then
		einfo "If you want to make Gajim run faster,"
		einfo "emerge dev-python/psyco, an extension"
		einfo "module which can speed up the executuion"
		einfo "of Python code."
	fi
}