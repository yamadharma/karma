# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
DESCRIPTION="JACK sound wrapper for OSS applications"
HOMEPAGE="http://www.craknet.net/joss"
SRC_URI="http://www.craknet.net/joss/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="media-libs/libsamplerate"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	sed -i "s@\(^libdir=\).*@\1/usr/lib@" joss
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dolib joss.so
	dobin joss
	dodoc AUTHORS README COPYING
}
