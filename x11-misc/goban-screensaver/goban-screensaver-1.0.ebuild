# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Replays historical games of go (aka wei-chi and baduk) on the screen"
MY_PN="${PN/%-screensaver}"
HOMEPAGE="http://www.draves.org/goban/"
MY_P="${MY_PN}-${PV}"
SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="|| ( (
			x11-libs/libX11
			x11-proto/xproto
		)
		virtual/x11
	)"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-Makefile.in.patch
	epatch ${FILESDIR}/${P}-root-and-id.patch
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc COPYING README README.screensaver
}
