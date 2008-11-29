# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python versionator

DESCRIPTION="Synchronization for GNOME"
HOMEPAGE="http://www.conduit-project.org"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="eog nautilus totem"

DEPEND="sys-apps/dbus
	>=dev-python/pygoocanvas-0.9.0
	>=dev-python/vobject-0.4.8
	>=dev-python/pyxml-0.8.4
	>=dev-python/pygtk-2.10.3
	>=dev-python/pysqlite-2.3.1
	>=dev-python/pygoocanvas-0.9.0
	eog? ( media-gfx/eog )
	nautilus? ( gnome-base/nautilus )
	totem? ( media-video/totem )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	find . -iname Makefile.in -print0 | xargs -0 sed -i -e 's|^py_compile = .*|py_compile = /bin/true|g'
}

src_compile() {
	econf \
		$(use_enable nautilus nautilus-extension) \
		$(use_with nautilus nautilus-extension-dir /usr/$(get_libdir)/nautilus/extensions-2.0/python-extensions/) \
		$(use_enable eog eog-plugin) \
		$(use_with eog eog-plugin-dir /usr/$(get_libdir)/eog/plugins/) \
                $(use_enable totem totem-plugin) \
                $(use_with totem totem-plugin-dir /usr/$(get_libdir)/totem/plugins/)

	emake py_compile=true || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/conduit/modules/
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/conduit/
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/conduit/modules/
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/conduit/
}
