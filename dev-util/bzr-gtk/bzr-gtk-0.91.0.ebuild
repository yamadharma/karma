# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils versionator

DESCRIPTION="A plugin for Bazaar that aims to provide GTK+ interfaces to most
Bazaar operations."
HOMEPAGE="http://bazaar-vcs.org/bzr-gtk"
SRC_URI="https://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="gtksourceview libnotify nautilus"

DEPEND=">=dev-lang/python-2.4
	=dev-util/bzr-$(get_version_component_range 1-2)*
	>=dev-python/pygtk-2.8
	>=dev-python/pycairo-1.0"
RDEPEND="${DEPEND}
	gtksourceview? ( dev-python/gnome-python-desktop )
	nautilus? ( dev-python/gnome-python )
	libnotify? (
		dev-python/notify-python
		dev-util/bzr-dbus
	 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_install() {
	distutils_src_install
	dodoc AUTHORS README
	if use nautilus; then
		insinto /usr/lib/nautilus/extensions-1.0/python
		doins nautilus-bzr.py
	fi
}
