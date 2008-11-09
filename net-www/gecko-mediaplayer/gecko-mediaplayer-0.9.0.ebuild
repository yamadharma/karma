# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GCONF_DEBUG=no

inherit gnome2 multilib

DESCRIPTION="A browser plug-in for GNOME MPlayer."
HOMEPAGE="http://code.google.com/p/gecko-mediaplayer"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	>=media-video/gnome-mplayer-${PV}
	|| ( >=net-libs/xulrunner-1.8
		=www-client/mozilla-firefox-2*
		=www-client/seamonkey-1*
		www-client/epiphany )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_install() {
	addpredict /etc/gconf/gconf.xml.defaults/.testing.writeability
	emake DESTDIR="${D}" install || die "emake install failed."

	dodir /usr/$(get_libdir)/nsbrowser/plugins

	mv "${D}"/usr/$(get_libdir)/nspr/mozilla/plugins/${PN}* \
		"${D}"/usr/$(get_libdir)/nsbrowser/plugins || die "mv plugins failed."

	rm -rf "${D}"/usr/share/doc/${PN}

	dodoc ChangeLog
}
