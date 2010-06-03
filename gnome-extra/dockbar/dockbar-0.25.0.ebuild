# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils multilib versionator


DESCRIPTION="Gnome taskbar applet with groupping and group manipulation"
HOMEPAGE="https://launchpad.net/dockbar"
SRC_URI="https://launchpad.net/dockbar/vanilla/${PV}/+download/${PN}-$(get_version_component_range 1-2).tar.gz"

SLOT=0
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pygobject
	dev-python/pygtk
	dev-python/gconf-python
	dev-python/libgnome-python
	dev-python/gnome-applets-python
	dev-python/gnome-vfs-python
	dev-python/libwnck-python
	dev-python/dbus-python
	dev-python/pyxdg"
DEPEND="${RDEPEND}"

S="${WORKDIR}/$(get_version_component_range 1-2)"

src_install() {
	exeinto /usr/bin
	doexe ${S}/${PN}/*.py || die "doexe failed"

	insinto /usr/$(get_libdir)/bonobo/servers
	doins GNOME_DockBarApplet.server || die "doins failed"

	dodir /usr/share/${PN}/themes
	insinto /usr/share/${PN}/themes
	doins share/${PN}/themes/* || die "doins failed"

	dodoc README Changelog
}
