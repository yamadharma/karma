# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

_PN="rofi"
#_PV="${PV}-wayland"
_P="${_PN}-${PV}"

DESCRIPTION="Wayland fork of rofi, a window switcher, run dialog and dmenu replacement"
HOMEPAGE="https://github.com/lbonn/${_PN}"
EGIT_REPO_URI="https://github.com/lbonn/${_PN}"
EGIT_BRANCH="wayland"
EGIT_SUBMODULES=( libgwater libnkutils )

if [[ "${PV}" != 9999 ]] ; then
	EGIT_COMMIT="${_PV}"
	KEYWORDS="amd64 x86 ~arm64"
else
	KEYWORDS=""
fi

LICENSE="MIT"
IUSE="+drun test +windowmode"
SLOT="0"

RDEPEND="dev-libs/libxdg-basedir
	x11-libs/startup-notification
	x11-libs/libxkbcommon[X,wayland]
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	gnome-base/librsvg:2
	dev-libs/glib:2
	x11-libs/pango[X]
	x11-libs/libXinerama
	x11-libs/cairo[X]
	virtual/jpeg
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? ( >=dev-libs/check-0.11 )
"
BDEPEND="${BDEPEND}
	dev-libs/wayland-protocols
"

src_configure() {
	local emesonargs=(
		$(meson_use drun)
		$(meson_use windowmode window)
		$(meson_feature test check)
		-Dwayland=enabled
	)

	meson_src_configure
}
