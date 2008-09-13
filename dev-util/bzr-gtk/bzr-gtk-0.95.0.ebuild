# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils versionator

MY_P="/${P/_rc/rc}"

DESCRIPTION="A plugin for Bazaar that aims to provide GTK+ interfaces to most
Bazaar operations."
HOMEPAGE="http://bazaar-vcs.org/bzr-gtk"
#SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
SRC_URI="http://samba.org/~jelmer/bzr/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="gpg gtksourceview libnotify nautilus"

DEPEND=">=dev-lang/python-2.4
	>=dev-util/bzr-1.3_rc1
	>=dev-python/pygtk-2.8
	nautilus? ( dev-python/nautilus-python )
	>=dev-python/pycairo-1.0"
RDEPEND="${DEPEND}
	gpg? ( app-crypt/seahorse )
	gtksourceview? ( dev-python/gnome-python-desktop )
	libnotify? (
		dev-python/notify-python
		dev-util/bzr-dbus
	 )"

S="${WORKDIR}/${MY_P}"
