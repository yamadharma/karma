# Copyright 2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vala
inherit meson
# inherit ltprune

DESCRIPTION="Set of programs to inspect and build Windows Installer (.MSI) files"
HOMEPAGE="https://wiki.gnome.org/msitools"
LICENSE="LGPL-2+"

SLOT="0"
#SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/${PV}/${P}.tar.xz"
KEYWORDS="amd64 ~arm ~arm64"
IUSE='nls rpath gnu-ld'

RDEPEND=(
	"dev-libs/glib:2"
	"sys-apps/util-linux[libuuid]"
	"dev-libs/libxml2"
	"gnome-extra/libgsf[introspection]"
	"$(vala_depend)"
	"app-arch/gcab[vala]"
	"gnome-extra/libgsf"
)
DEPEND_A="$RDEPEND"

src_prepare() {
	eapply_user
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
	)
	meson_src_configure
}

src_install() {
	default
	meson_src_install
}
