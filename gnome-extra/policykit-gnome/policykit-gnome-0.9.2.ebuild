# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

inherit gnome2

MY_PN="PolicyKit-gnome"

DESCRIPTION="PolicyKit policies and configurations for the GNOME desktop"
HOMEPAGE="http://hal.freedesktop.org/docs/PolicyKit"
SRC_URI="http://hal.freedesktop.org/releases/${MY_PN}-${PV}.tar.bz2"

LICENSE="|| ( LGPL-2 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND=">=dev-libs/dbus-glib-0.71
	>=x11-libs/gtk+-2.10
	>=gnome-base/libgnome-2.20
	>=gnome-base/libgnomeui-2.20
	>=sys-auth/policykit-0.9"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=app-text/scrollkeeper-0.3.14
	>=dev-util/intltool-0.35.0
	sys-devel/gettext"

pkg_setup()
{
		G2CONF="--disable-examples"
}
