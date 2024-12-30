# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vala meson

DESCRIPTION="A keybinding viewer for i3 and other programs"
HOMEPAGE="https://github.com/regolith-linux/remontoire"
SRC_URI="https://github.com/regolith-linux/remontoire/archive/refs/tags/r3_3-beta1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ~ppc64 ~sparc x86"
IUSE=""
RESTRICT=""
S=${WORKDIR}/${PN}-r3_3-beta1

COMMON_DEPEND="
	>=dev-libs/glib-2.45.8:2
	>=x11-libs/gtk+-3.22:3
"
RDEPEND="${COMMON_DEPEND}
"
DEPEND="${COMMON_DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_configure() {
	# local emesonargs=(
	# 	$(meson_use test enable-tests)
	# )
	vala_setup
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
