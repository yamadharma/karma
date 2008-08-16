# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/${PN}
inherit kde4overlay-meta

DESCRIPTION="X terminal for use with KDE."
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	>=x11-libs/libxklavier-3.2
	x11-libs/libXrender
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	x11-apps/bdftopcf
	x11-proto/kbproto
	x11-proto/renderproto"
RESTRICT="test"

src_unpack() {
	if use htmlhandbook; then
		KMEXTRA="${KMEXTRA}
			apps/doc/${PN}"
	fi

	kde4overlay-meta_src_unpack
}
