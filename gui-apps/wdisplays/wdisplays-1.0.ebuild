# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="xrandr clone for wlroots compositors"
HOMEPAGE="https://github.com/cyclopsian/wdisplays"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyclopsian/wdisplays"
else
	SRC_URI="https://github.com/cyclopsian/wdisplays/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

LICENSE="ISC"
SLOT="0"

DEPEND="
	dev-libs/wayland
	x11-libs/gtk+:3
	media-libs/libepoxy
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
"
